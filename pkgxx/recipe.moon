
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
		@summary = recipe.summary
		@description = recipe.description
		@dirname = @dirname or "#{@name}-#{@version}"

		@license = recipe.license
		@copyright = recipe.copyright

		@groups = recipe.groups or {}

		@conflicts = recipe.conflicts or {}
		@dependencies = recipe.dependencies or {}
		@provides = recipe.provides or {}

		@architecture = @context.architecture

		@maintainer = recipe.maintainer or recipe.packager
		@packager = recipe.packager
		@contributers = recipe.contributors

		@class = recipe.class

		@sources = {}
		@sources = @\parseSources recipe

		@buildInstructions =
			configure: recipe.configure,
			build: recipe.build,
			install: recipe.install

		@\applyDistributionRules recipe

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
				if not data.name
					data.name = split

				-- Splits will need much more data than this.
				splits[#splits+1] = setmetatable {
					files: data.files
				}, __index: @

				@@.applyDiff splits[#splits], data

		splits

	applyDistributionRules: (recipe) =>
		distribution = @context.configuration.distribution
		module = @context.modules[distribution]

		if module
			if module.alterRecipe
				module.alterRecipe @
		else
			ui.warning "No module found for this distribution: " ..
				"'#{distribution}'."
			ui.warning "Your package is very unlike to comply to " ..
				"your OS’ packaging guidelines."

		-- Not very elegant.
		if recipe.os and recipe.os[distribution]
			@@.applyDiff @, recipe.os[distribution]

		for split in *@splits
			os = recipe.splits[split.name].os

			if os and os[distribution]
				@@.applyDiff split, os[distribution]

	applyDiff: (diff) =>
		if diff.name
			@name = diff.name
		if diff.version
			@version = diff.version
		if diff.release
			@release = diff.release

		if diff.dependencies
			@dependencies = diff.dependencies
		if diff.conflicts
			@conflicts = recipe.conflicts or {}
		if diff.provides
			@provides = recipe.provides or {}

		if diff.groups
			@groups = recipe.groups or {}

		if diff.summary
			@summary = diff.summary
		if diff.description
			@description = diff.description

		if diff.license
			@license = diff.license
		if diff.copyright
			@copyright = diff.copyright

		if diff.class
			@class = diff.class

	stripFiles: =>
		fs.changeDirectory (@\packagingDirectory "_"), ->
			find = io.popen "find . -type f"

			line = find\read "*line"
			while line
				p = io.popen "file -b '#{line}'"
				type = p\read "*line"
				p\close!

				if type\match ".*ELF.*executable.*not stripped"
					ui.debug "Stripping '#{line}'."
					os.execute "strip --strip-all '#{line}'"
				elseif type\match ".*ELF.*shared object.*not stripped"
					ui.debug "Stripping '#{line}'."
					os.execute "strip --strip-unneeded'#{line}'"
				elseif type\match "current ar archive"
					ui.debug "Stripping '#{line}'."
					os.execute "strip --strip-debug '#{line}'"

				line = find\read "*line"

			find\close!

	compressManpages: =>
		fs.changeDirectory (@\packagingDirectory "_"), ->
			-- FIXME: hardcoded directory spotted.
			find = io.popen "find usr/share/man -type f"

			file = find\read "*line"
			while file
				unless file\match "%.gz$" or file\match "%.xz$" or
				       file\match "%.bz2$"
					switch @context.compressionMethod
						when "gz"
							os.execute "gzip -9 '#{file}'"
						when "bz2"
							os.execute "bzip2 -9 '#{file}'"
						when "xz"
							os.execute "xz -9 '#{file}'"

				file = find\read "*line"

			find\close!

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

			if @context.configuration.verbosity < 5
				logfile =  "#{@context.packagesDirectory}/" ..
					"#{name}-#{version}-#{release}.log"

				code = "(#{code}) 2>> #{logfile} >> #{logfile}"

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

		@\stripFiles!
		@\compressManpages!

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

		module = @context.modules[@context.configuration["package-manager"]]

		if module.package
			@\packageSplit module, @

			for split in *@splits
				@\packageSplit module, split
		else
			-- Should NOT happen.
			error "No module is available for the package manager "..
				"'#{@configuration['package-manager']}'."

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

