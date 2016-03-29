
toml = require "toml"

ui = require "pkgxx.ui"
fs = require "pkgxx.fs"
macro = require "pkgxx.macro"
sources = require "pkgxx.sources"

macroList = =>
	l = {
		pkg: @\packagingDirectory "_"
	}

	for name, path in pairs @context.prefixes
		l[name] = path

	l

swapKeys = (tree, oldKey, newKey) ->
	tree[oldKey], tree[newKey] = tree[newKey], tree[oldKey]

	for key, value in pairs tree
		if (type value) == "table"
			tree[key] = swapKeys value, oldKey, newKey

	tree

class
	new: (filename, context) =>
		file = io.open filename, "r"

		unless file
			error "could not open recipe", 0

		recipe, e = toml.parse (file\read "*all"), {strict: false}

		swapKeys recipe, "build-dependencies", "buildDependencies"

		file\close!

		@context = context

		recipe = macro.parse recipe, macroList @

		-- FIXME: sort by name or something.
		@splits = @\parseSplits recipe

		@origin = @

		@\applyDiff recipe

		@class = @class or @\guessClass @

		@release = @release or 1

		unless @dirname
			if @version
				@dirname = "#{@name}-#{@version}"
			else
				@dirname = recipe.name

		@conflicts    = @conflicts or {}
		@dependencies = @dependencies or {}
		@buildDependencies = @buildDependencies or {}
		@provides     = @provides or {}
		@groups       = @groups or {}
		@options      = @options or {}

		@architecture = @context.architecture
		@sources = sources.parse recipe

		@buildInstructions =
			configure: recipe.configure,
			build: recipe.build,
			install: recipe.install

		@recipe = recipe -- Can be required for module-defined fields.
		@recipeAttributes = lfs.attributes filename

		@\applyDistributionRules recipe

		@\setTargets!

		@\checkRecipe!

	parse: (string) =>
		parsed = true
		while parsed
			string, parsed = macro.parseString string, (macroList @), {}

		string

	-- Is meant to be usable after package manager or architecture
	-- changes, avoiding the creation of a new context.
	setTargets: =>
		module = @context.modules[@context.packageManager]

		unless module and module.target
			ui.error "Could not set targets. Wrong package manager module?"
			return nil

		@target = module.target @
		for split in *@splits
			split.target = module.target split

	getTargets: =>
		i = 0

		return ->
			i = i + 1

			if i - 1 == 0
				return @target
			elseif i - 1 <= #@splits
				return @splits[i - 1].target

	parseSplits: (recipe) =>
		splits = {}

		if recipe.splits
			for splitName, data in pairs recipe.splits
				if not data.name
					data.name = splitName

				-- Splits will need much more data than this.
				split = setmetatable {
					os: data.os,
					files: data.files
				}, __index: @

				splits[#splits+1] = split

				@@.applyDiff split, data

				split.class = split.class or @\guessClass split

		splits

	applyDistributionRules: (recipe) =>
		distribution = @context.configuration.distribution
		module = @context.modules[distribution]

		if module
			if module.alterRecipe
				module.alterRecipe @

			ui.debug "Distribution: #{module.name}"
			if module.autosplits
				oldIndex = #@splits

				newSplits = module.autosplits @
				newSplits = macro.parse newSplits, macroList @

				for split in *@\parseSplits splits: newSplits
					ui.debug "Registering automatic split: #{split.name}."

					if not @\hasSplit split.name
						split.automatic = true
						@splits[#@splits+1] = split
					else
						ui.debug " ... split already exists."
		else
			ui.warning "No module found for this distribution: " ..
				"'#{distribution}'."
			ui.warning "Your package is very unlike to comply to " ..
				"your OS’ packaging guidelines."

		-- Not very elegant.
		if recipe.os and recipe.os[distribution]
			@@.applyDiff @, recipe.os[distribution]

		for split in *@splits
			os = split.os

			if os and os[distribution]
				@@.applyDiff split, os[distribution]

	guessClass: (split) =>
		if split.name\match "-doc$"
			"documentation"
		elseif split.name\match "-dev$" or split.name\match "-devel$"
			"headers"
		elseif split.name\match "^lib"
			"library"
		else
			"binary"

	checkRecipe: =>
		module = @context.modules[@context.packageManager]
		if module and module.check
			r, e = module.check @

			if e and not r
				error e, 0

	hasSplit: (name) =>
		for split in *@splits
			if split.name == name
				return true

	hasOption: (option) =>
		for opt in *@options
			if opt == option
				return true

	applyDiff: (diff) =>
		if diff.name
			@name = diff.name
		if diff.version
			@version = diff.version
		if diff.release
			@release = diff.release

		if diff.dependencies
			@dependencies = diff.dependencies
		if diff.buildDependencies
			@buildDependencies = diff.buildDependencies
		if diff.conflicts
			@conflicts = diff.conflicts
		if diff.provides
			@provides = diff.provides
		if diff.groups
			@groups = diff.groups
		if diff.options
			@options = diff.options

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
					os.execute "strip --strip-unneeded '#{line}'"
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

	buildNeeded: =>
		for self in *{self, table.unpack self.splits}
			if self.automatic
				continue

			attributes = lfs.attributes "" ..
				"#{@context.packagesDirectory}/#{@target}"
			unless attributes
				return true

			if attributes.modification < @recipeAttributes.modification
				ui.info "Recipe is newer than packages."
				return true

	checkDependencies: =>
		module = @context.modules[@context.packageManager]

		unless module and module.isInstalled
			-- FIXME: Make this a real warning once it’s implemented.
			return nil, "unable to check dependencies"

		deps = {}
		for name in *@dependencies
			table.insert deps, name
		for name in *@buildDependencies
			table.insert deps, name

		for name in *deps
			if not module.isInstalled name
				-- FIXME: Check the configuration to make sure it’s tolerated.
				--        If it isn’t, at least ask interactively.
				ui.detail "Installing missing dependency: #{name}"
				@\installDependency name

	installDependency: (name) =>
		module = @context.modules[@context.dependenciesManager]
		if not (module and module.installDependency)
			module = @context.modules[@context.packageManager]

		if not (module and module.installDependency)
			return nil, "no way to install packages"

		module.installDependency name

	download: =>
		ui.info "Downloading…"

		for source in *@sources
			if (sources.download source, @context) ~= true
				return

		true

	updateVersion: =>
		local v

		for source in *@sources
			module = @context.modules[source.protocol]

			unless module
				continue

			if module.getVersion
				v = fs.changeDirectory @context.sourcesDirectory, ->
					module.getVersion source

				if not @version
					@version = v

		@\setTargets!

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
					-- FIXME: -r was needed for repositories and stuff.
					--        We need to modularize “extractions”.
					os.execute "cp -r " ..
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
				return os.execute code
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
			ui.error "Build failure. Could not configure."
			return nil, e

		success, e = (@\execute "build", true)
		if not success
			ui.error "Build failure. Could not build."
			return nil, e

		success, e = (@\execute "install")
		if not success
			ui.error "Build failure. Could not install."
			return nil, e

		@\stripFiles!
		@\compressManpages!

		true

	split: =>
		mainPkgDir = @\packagingDirectory "_"

		for split in *@splits
			if split.files
				if split.automatic and not @\splitHasFiles split, mainPkgDir
					ui.debug "No file detected for #{split.name}. Ignoring."
					return

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

	splitHasFiles: (split, baseDir) =>
		baseDir = baseDir or @\packagingDirectory split.name
		for file in *split.files
			fileName = baseDir .. "/" .. file

			if not fs.attributes fileName
				return false

		return true

	package: =>
		ui.info "Packaging…"
		@\split!

		module = @context.modules[@context.packageManager]

		if module.package
			@\packageSplit module, @

			for split in *@splits
				@\packageSplit module, split
		else
			-- Should NOT happen.
			error "No module is available for the package manager "..
				"'#{@configuration['package-manager']}'."

	-- Checks that the split has the files it’s supposed to have in .files.

	packageSplit: (module, split) =>
		local splitName
		if split == @
			splitName = "_"
		else
			splitName = split.name

		if split.automatic and not @\splitHasFiles split
			ui.debug "Not building automatic split: #{split.name}"

			return

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

