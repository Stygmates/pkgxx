
toml = require "toml"

ui = require "pkgxx.ui"
fs = require "pkgxx.fs"
macro = require "pkgxx.macro"
sources = require "pkgxx.sources"

class
	new: (filename, context) =>
		file = io.open filename, "r"

		recipe, e = toml.parse (file\read "*all"), {strict: false}

		file\close!

		@context = context

		recipe = macro.parse recipe, {
			pkg: "#{@\packagingDirectory "_"}"
		}

		-- FIXME: sort by name or something.
		@splits = @\parseSplits recipe

		@name = recipe.name
		@version = recipe.version
		@release = recipe.release or 1
		@dirname = @dirname or "#{@name}-#{@version}"
		@sources = {}

		@sources = @\parseSources recipe

		@buildInstructions =
			configure: recipe.configure,
			build: recipe.build,
			install: recipe.install

	parseSources: (recipe) =>
		local sources

		sources = switch type recipe.sources
			when "string"
				{ recipe.sources }
			when "nil"
				{}
			else
				recipe.sources

		for i = 1, #sources
			source = sources[i]
			url = source\gsub " -> .*", ""

			sources[i] = {
				filename: url\gsub ".*/", "",
				url: url
			}

		sources

	parseSplits: (recipe) =>
		splits = {}

		if recipe.splits
			for split, data in pairs recipe.splits
				-- Splits will need much more data than this.
				splits[#splits+1] = setmetatable {
					name: split,
					version: data.version,
					release: data.release,

					files: data.files
				}, __index: @

		splits

	buildingDirectory: =>
		"#{@context.buildingDirectory}/src/" ..
			"#{@name}-#{@version}-#{@release}"

	packagingDirectory: (name) =>
		"#{@context.buildingDirectory}/pkg/#{name}"

	download: =>
		ui.info "Downloading…"

		for source in *@sources
			sources.download source, @context

	prepareBuild: =>
		fs.mkdir @\buildingDirectory!
		fs.mkdir @\packagingDirectory "_"

		for split in *@splits
			fs.mkdir @\packagingDirectory split.name

	extract: =>
		ui.info "Extracting…"

		fs.changeDirectory @\buildingDirectory!, ->
			for source in *@sources
				if source.filename\match "%.tar%.[a-z]*$"
					ui.detail "Extracting '#{source.filename}'."
					os.execute "tar xf " ..
						"'#{@context.sourcesDirectory}/" ..
						"#{source.filename}'"
				else
					ui.detail "Copying '#{source.filename}'."
					os.execute "cp " ..
						"'#{@context.sourcesDirectory}/" ..
						"#{source.filename}' ./"

	-- @param name The name of the “recipe function” to execute.
	execute: (name, critical) =>
		ui.debug "Executing '#{name}'."

		if @buildInstructions[name]
			code = table.concat @buildInstructions[name], "\n"

			code = "set -x #{'-e' if critical else ''}\n#{code}"

			unless @context.verbose
				code = "(#{code}) > " ..
					"#{@context.packagesDirectory}/" ..
					"#{name}-#{version}-#{release}.log"

			fs.changeDirectory @\buildingDirectory!, ->
				r, e = pcall -> os.execute code

				if not r
					ui.error "#{e}"

				return r, e
		else
			@\executeModule name, critical

	executeModule: (name, critical) =>
		local r

		for modname, module in pairs @context.modules
			if module[name]
				-- FIXME: Not very readable. Please fix.
				r, e = fs.changeDirectory @\buildingDirectory!, ->
					module[name] @

				if r or e
					return r, e

		return nil, "no suitable module found"

	build: =>
		@\prepareBuild!

		@\extract!

		ui.info "Building…"

		success, e = (@\execute "configure")
		if not success
			return nil, e

		success, e = (@\execute "build", true)
		if not success
			return nil, e

		success, e = (@\execute "install")
		if not success
			return nil, e

		true

	split: =>
		for split in *@splits
			if split.files
				ui.detail "Splitting '#{split.name}'."

				for file in *split.files
					source = (@\packagingDirectory "_") .. file
					destination = (@\packagingDirectory split.name) ..
						file
					ui.debug "split: #{source} -> #{destination}"

					-- XXX: We need to be more cautious about
					--      permissions here.
					fs.mkdir destination\gsub "/[^/]*$", ""
					os.execute "mv '#{source}' '#{destination}'"

	package: =>
		ui.info "Packaging…"
		@\split!

		for name, module in pairs @context.modules
			if module.package
				@\packageSplit module, @

				for split in *@splits
					@\packageSplit module, split

	packageSplit: (module, split) =>
		local splitName
		if split == @
			splitName = "_"
		else
			splitName = split.name

		fs.changeDirectory (@\packagingDirectory splitName), ->
			module.package split

	clean: =>
		ui.info "Cleaning…"
		ui.detail "Removing '#{@\buildingDirectory!}'."
		fs.remove @\buildingDirectory!, {
			force: true
		}

	__tostring: =>
		"<pkgxx:Recipe: #{@name}-#{@version}-#{@release}>"

