
--- Operations and data on single recipes.
--
-- It is useful to know that a Recipe can generate multiple packages.
--
-- @classmod Recipe
-- @see Package
-- @see Context
---

toml = require "toml"

ui = require "pkgxx.ui"
fs = require "pkgxx.fs"
macro = require "pkgxx.macro"
sources = require "pkgxx.sources"

Atom = require "pkgxx.atom"
Package = require "pkgxx.package"

macroList = =>
	l = {
		pkg: @\packagingDirectory!
	}

	for name in *@context.__class.prefixes
		l[name] = @context\getPrefix name

	-- We should remove those. They may generate clashes with the collections’
	-- prefixes generated by Context\getPrefix.
	for name, value in pairs @context.configuration
		l[name] = value

	l

swapKeys = (tree, oldKey, newKey) ->
	tree[oldKey], tree[newKey] = tree[newKey], tree[oldKey]

	for key, value in pairs tree
		if (type value) == "table"
			tree[key] = swapKeys value, oldKey, newKey

	tree

has = (e, t) ->
	for i in *t
		if e == i
			return true

class
	--- Throws errors when the file cannot be opened or parsed.
	--
	-- @tparam Context context pkgxx Context in which to import the recipe.
	--
	-- @see Context
	new: (context) =>
		--- Context in which the Recipe has been created.
		-- @attribute context
		@context = context

	--- Imports a recipe’s data from a package.toml file.
	--
	-- @param filename Filename of the recipe to parse.
	importTOML: (filename) =>
		--- Name of the file from which the recipe has been generated.
		-- @attribute filename
		@filename = filename

		file, reason = io.open filename, "r"

		unless file
			error reason, 0

		recipe, reason = toml.parse (file\read "*all"), {strict: false}

		unless recipe
			error reason, 0

		swapKeys recipe, "build-dependencies", "buildDependencies"

		file\close!

		recipe = macro.parse recipe, macroList @

		--- Name of the recipe.
		-- @attribute name
		@name = recipe.name
		--- Version of the software to be packaged.
		-- @attribute version
		@version = recipe.version
		--- Version of the recipe itself.
		--
		-- The `release` attribute should always be incremented when the recipe is updated.
		--
		-- @attribute release
		@release = recipe.release or 1

		--- The person who wrote the recipe.
		-- @attribute packager
		@packager = recipe.packager
		--- The person who updates and maintains the recipe.
		-- Defaults to `@packager`.
		-- @attribute maintainer
		@maintainer = recipe.maintainer or @packager
		--- Homepage of the packaged project.
		-- @attribute url
		@url = recipe.url

		--- Metadata to check automagically if the recipe is out of date.
		-- @attribute watch

		--- @fixme Should have its own class and do its own checks.

		--- @fixme Is relatively easy to test… and yet has no test.
		@watch = recipe.watch
		if @watch
			@watch.url = @watch.url or @url

			unless @watch.selector or @watch.lasttar or @watch.execute
				ui.warning "No selector in [watch]. Removing watch."
				@watch = nil

		--- Describes the name of the directory in which the main sources are stored.
		-- This value might be used by modules to configure their build process.
		-- Defaults to `"#{@name}-#{@version}"` if `@version` exists.
		-- Defaults to `@name` otherwise.
		-- @attribute dirname
		@dirname = recipe.dirname
		unless @dirname
			if @version
				@dirname = "#{@name}-#{@version}"
			else
				@dirname = recipe.name

		--- List of sources linked to the recipe.
		-- @see Source
		-- @attribute sources
		@sources = sources.parseAll recipe

		--- Instructions to build the software.
		-- Contains three fields: `configure`, `build` and `install`.
		-- @attribute buildInstructions

		--- @fixme Each field should be its own instance of the same, common class, and that class should have its own checks.
		bs = recipe["build-system"]
		@buildInstructions =
			configure: recipe.configure or bs,
			build: recipe.build or bs,
			install: recipe.install or bs

		--- A list of Atoms describing the recipe’s build-time dependencies.
		-- @see Atom
		-- @attribute buildDependencies
		@buildDependencies = {}
		for string in *(recipe.buildDependencies or {})
			table.insert @buildDependencies, Atom string

		--- The source upon which the recipe is built.
		-- @attribute recipe
		@recipe = recipe --- @fixme That field should be unavailable.
		--- Attributes of the recipe’s file.
		-- attribute recipeAttributes
		@recipeAttributes = fs.attributes filename --- @fixme That field should be unavailable.

		--- Packages described by the recipe.
		-- @attribute packages
		@packages = @\parsePackages recipe

		-- self.watch guess.
		-- Is done very long after the possible static definition of watch because modules may need to have access to other values.
		unless @watch
			for _, module in pairs @context.modules
				if module.watch
					with watch = module.watch @
						if watch
							-- FIXME: Maybe we could do some additionnal checks.
							@watch = watch

		--- Class of the recipe.
		-- @attribute class
		-- @see Package.class

		--- @fixme Will be removed from Recipe. Recipes having a class makes no sense.
		@class or= @\guessClass!

		@\applyDistributionRules recipe

		-- Importing packages’ dependencies in the build-deps.
		for package in *@packages
			for atom in *package.dependencies
				if not has atom, @buildDependencies
					@buildDependencies[#@buildDependencies+1] = atom

		--- Options with which to build the package.
		-- See the various postBuild modules for specific entries to add to the `.options` field.
		-- @attribute options

		-- FIXME: Broken since Atom exist.
		for package in *@packages
			if @context.collection
				package.name = @context.collection ..
					"-" .. package.name

				for list in *{
					"conflicts",
					"dependencies",
					"buildDependencies",
					"provides",
					"groups",
					"options",
				}
					for index, name in pairs package[list]
						package[list][index] = @context.collection ..
							"-" .. name

	---
	-- Finalizes a recipe and makes it ready for use.
	finalize: =>
		@\setTargets!

		@\checkRecipe!

	parse: (string) =>
		parsed = true
		while parsed
			string, parsed = macro.parseString string, (macroList @), @

		string

	-- Is meant to be usable after package manager or architecture
	-- changes, avoiding the creation of a new context.
	setTargets: =>
		module = @context.modules[@context.packageManager]

		unless module and module.package
			ui.error "Could not set targets. Wrong package manager module?"
			return nil

		for package in *@packages
			package.target = module.package.target package

		@target = @packages[1].target

	---
	-- Lists the filenames and packages this recipe defines.
	-- @treturn function Iterator over the pairs of filename and Package defined by the Recipe.
	-- @see Package
	getTargets: =>
		i = 1

		return ->
			i = i + 1

			if i - 1 <= #@packages
				package = @packages[i - 1]

				return package.target, package

	getLogFile: =>
		"#{@context.packagesDirectory}/#{@name}-#{@version}-#{@release}.log"

	parsePackages: (recipe) =>
		packages = {}

		packages[1] = Package
			origin: @

		packages[1]\applyDiff recipe

		if recipe.splits
			for packageName, data in pairs recipe.packages
				-- Packages will need much more data than this.
				-- FIXME: Package!? Target!?
				package = Package
					name: packageName
					origin: @
					os: data.os
					files: data.files

				package\applyDiff data

				package.class = package.class or package\guessClass!

				packages[#packages+1] = package

		packages

	applyDistributionDiffs: (recipe, distribution) =>
		if recipe.os and recipe.os[distribution]
			@packages[1]\applyDiff recipe.os[distribution]

	applyDistributionRules: (recipe) =>
		distribution = @context.distribution
		module = @context.modules[distribution] or {}

		@\applyDistributionDiffs recipe, distribution

		if module.alterRecipe
			module.alterRecipe self, recipe

		for package in *@packages
			os = package.os

			if os and os[distribution]
				package\applyDiff os[distribution]

		if module
			ui.debug "Distribution: #{module.name}"

			if module.autosplits
				ui.debug "Trying module '#{module.name}'."
				newPackages = module.autosplits @
				newPackages = macro.parse newPackages, macroList @

				for package in *@\parsePackages splits: newPackages
					ui.debug "Registering automatic package: #{package.name}."

					if not @\hasPackage package.name
						package.automatic = true
						@packages[#@packages+1] = package
					else
						ui.debug " ... package already exists."
		else
			ui.warning "No module found for this distribution: " ..
				"'#{distribution}'."
			ui.warning "Your package is unlikely to comply to " ..
				"your OS’ packaging guidelines."

	guessClass: (package) ->
		if package.name\match "-doc$"
			"documentation"
		elseif package.name\match "-dev$" or package.name\match "-devel$"
			"headers"
		elseif package.name\match "^lib"
			"library"
		else
			"binary"

	checkRecipe: =>
		module = @context.modules[@context.packageManager]
		if module and module.check
			r, e = module.check @

			if e and not r
				error e, 0

	hasPackage: (name) =>
		for package in *@packages
			if package.name == name
				return true

	postBuildHooks: =>
		for module in *@context.modules
			if module.postBuild
				fs.directory @\packagingDirectory!, ->
					module.postBuild @

	buildingDirectory: =>
		"#{@context.buildingDirectory}/src/" ..
			"#{@name}-#{@version}-#{@release}"

	packagingDirectory: (name) =>
		unless name
			name = "_"

		"#{@context.buildingDirectory}/pkg/#{name}"

	---
	-- Checks whether the recipe’s packages need updating or rebuilding.
	-- @treturn boolean Build status.
	buildNeeded: =>
		for self in *self.packages
			if self.automatic
				continue

			attributes = fs.attributes "" ..
				"#{@context.packagesDirectory}/#{@target}"
			unless attributes
				return true

			if attributes.modification < @recipeAttributes.modification
				ui.info "Recipe is newer than packages."
				return true

	---
	-- Checks whether the recipe’s dependencies and build-dependencies are
	-- installed, and tries to install them if they are not.
	checkDependencies: =>
		ui.info "Checking dependencies…"

		deps = {}
		for atom in *@buildDependencies
			table.insert deps, atom

		for atom in *deps
			unless @context\isAtomInstalled atom
				-- FIXME: Check the configuration to make sure it’s tolerated.
				--        If it isn’t, at least ask interactively.
				ui.detail "Installing missing dependency: #{atom.name}"
				@\installDependency atom.name

	---
	-- Installs a package by name.
	-- @tparam string name Name of the package to install.
	installDependency: (name) =>
		-- @fixme Should probably be in Context. =/
		module = @context.modules[@context.dependenciesManager]
		if not (module and module.installDependency)
			module = @context.modules[@context.packageManager]

		if not (module and module.installDependency)
			return nil, "no way to install packages"

		module.installDependency name

	---
	-- Downloads the recipe’s sources.
	--
	-- @treturn boolean Boolean indicating whether or not the downloads succeeded.
	download: =>
		ui.info "Downloading…"

		for source in *@sources
			if (sources.download source, @context) ~= true
				return

		true

	---
	-- Generates the recipe’s version from its sources.
	--
	-- Is useless for recipes with static versions, but is useful if a recipe
	-- is of a development version from a git repository or any similar
	-- situation.
	updateVersion: =>
		for source in *@sources
			module = @context.modules[source.protocol]

			unless module
				continue

			if module.getVersion
				fs.changeDirectory @context.sourcesDirectory, ->
					success, version = pcall ->
						module.getVersion source

					if success and not @version
						@version = version

		@\setTargets!

	prepareBuild: =>
		fs.mkdir @\buildingDirectory!
		fs.mkdir @\packagingDirectory!

		for package in *@packages
			fs.mkdir @\packagingDirectory package.name

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

	---
	-- Used internally by @\build.
	--
	-- @param name The name of the “recipe function” to execute.
	-- @see Recipe\build
	execute: (name, critical) =>
		ui.debug "Executing '#{name}'."

		if (type @buildInstructions[name]) == "table"
			code = table.concat @buildInstructions[name], "\n"

			code = "set -x -e\n#{code}"

			if @context.configuration.verbosity < 5
				logfile = @\getLogFile!

				lf = io.open logfile, "w"
				if lf
					lf\close!

				code = "(#{code}) 2>> #{logfile} >> #{logfile}"

			fs.changeDirectory @\buildingDirectory!, ->
				return os.execute code
		else
			@\executeModule name, critical

	executeModule: (name, critical) =>
		if (type @buildInstructions[name]) == "string"
			module = @context.modules[@buildInstructions[name]]

			return fs.changeDirectory @\buildingDirectory!, ->
				module[name] @
		else
			testName = "can#{(name\sub 1, 1)\upper!}#{name\sub 2, #name}"

			for _, module in pairs @context.modules
				if module[name]
					local finished

					r, e = fs.changeDirectory @\buildingDirectory!, ->
						if module[testName] @
							finished = true

							return module[name] @

					if finished
						return r, e

		return nil, "no suitable module found"

	---
	-- Builds the recipe.
	--
	-- This method does not build the packages themselves.
	--
	-- @see Package
	-- @see Recipe\package
	build: =>
		@\prepareBuild!

		@\extract!

		ui.info "Building…"

		success, e = @\execute "configure"
		if not success
			ui.error "Build failure. Could not configure."
			return nil, e

		success, e = @\execute "build", true
		if not success
			ui.error "Build failure. Could not build."
			return nil, e

		success, e = @\execute "install"
		if not success
			ui.error "Build failure. Could not install."
			return nil, e

		ui.info "Doing post-build verifications."
		@\postBuildHooks!

		true

	split: =>
		for package in *@packages
			if package.files
				if package.automatic and not package\hasFiles!
					ui.debug "No file detected for #{package.name}. Ignoring."
					continue

				package\moveFiles!

		-- FIXME: A bit hacky. We need packaging directories and fake roots
		--        to be different.
		fs.remove @\packagingDirectory @packages[1].name
		fs.execute @, "mv '#{@\packagingDirectory!}' " ..
			"'#{@\packagingDirectory @packages[1].name}'"

	---
	-- Creates packages from the built software.
	-- @see Recipe\build
	package: =>
		ui.info "Packaging…"
		@\split!

		module = @context.modules[@context.packageManager]

		if module.package
			for package in *@packages
				package\package module
		else
			-- Should NOT happen.
			error "No module is available for the package manager "..
				"'#{@configuration['package-manager']}'."

	---
	-- Removes the recipe’s temporary building directories.
	clean: =>
		ui.info "Cleaning…"
		ui.detail "Removing '#{@\buildingDirectory!}'."

		-- Sort of necessary, considering the directories and files are
		-- root-owned. And they have to if we want our packages to be valid.
		os.execute "sudo rm -rf '#{@\buildingDirectory!}'"

	---
	-- Prints potential defects or missing data in the recipe.
	lint: =>
		e = 0

		unless @name
			ui.error "no 'name' field"
			e = e + 1
		unless @sources
			ui.error "no 'sources' field"
			e = e + 1

		unless @version
			isVersionable = false

			for source in *@sources
				m = @context.modules[source.protocol]

				if m and m.getVersion
					isVersionable = true

					break

			unless isVersionable
				ui.error "no 'version' field"
				e = e + 1

		unless @url
			ui.warning "no 'url' field"
			e = e + 1

		unless @packager
			ui.warning "no 'packager' field"
			e = e + 1

		unless @watch
			ui.warning "no 'watch' section"
		else
			with @watch
				unless .selector or .lasttar or .execute
					ui.warning "unusable 'watch', needs a selector, " ..
						"lasttar or execute field"

		for package in *@packages
			with self = package
				ui.detail @name
				unless @summary
					ui.warning "no 'summary' field"
					e = e + 1
				unless @description
					ui.warning "no 'description' field"
					e = e + 1

				unless @options
					ui.warning "no 'options' field"
					e = e + 1

				unless @dependencies
					ui.warning "no 'dependencies' field"
					e = e + 1

		e

	---
	-- Checks whether or not the recipe is up to date.
	--
	-- It may need access to recent sources to do so.
	--
	-- @see Recipe\download
	isUpToDate: =>
		if @watch
			local p
			-- FIXME: We need to abstract those curl calls.
			-- FIXME: sort -n is a GNU extension.
			-- FIXME: hx* come from the html-xml-utils from the w3c. That’s
			--        an unusual external dependency we’d better get rid of.
			--        We could switch to https://github.com/msva/lua-htmlparser,
			--        but there could be issues with Lua 5.1. More testing needed.
			if @watch.selector
				ui.debug "Using the “selector” method."
				p = io.popen "curl -sL '#{@watch.url}' | hxnormalize -x " ..
					"| hxselect '#{@watch.selector}' -c"
			elseif @watch.lasttar
				ui.debug "Using the “lasttar” method."
				p = io.popen "curl -sL '#{@watch.url}' | hxnormalize -x " ..
					"| hxselect -c 'a' -s '\n' " ..
					"| grep '#{@watch.lasttar}' " ..
					"| sed 's&#{@watch.lasttar}&&;s&\\.tar\\..*$&&' | sort -rn"
			elseif @watch.execute
				ui.debug "Executing custom script."
				p = io.popen @watch.execute

			version = p\read "*line"
			success, _, r = p\close!

			-- 5.1 compatibility sucks.
			unless (r and r == 0 or success) and version
				return nil, nil, "could not check", "child process failed"

			if version
				version = version\gsub "^%s*", ""
				version = version\gsub "%s*$", ""

			if @watch.subs
				for pair in *@watch.subs
					unless (type pair) == "table" and #pair == 2
						ui.warning "Invalid substitution. Substitution is not a pair."
						continue

					unless (type pair[1] == "string") and (type pair[2] == "string")
						ui.warning "Invalid substitution. Substitution is not a pair of strings."

						continue

					version = version\gsub pair[1], pair[2]

			return version == @version, version

	---
	-- Generates a dependency tree for the recipe.
	--
	-- May need access to other recipes.
	depTree: =>
		isInstalled = do
			module = @context.modules[@context.packageManager]
			f = if module
				module.isInstalled
			else
				ui.warning "Unable to determine installed dependencies."

			f or -> false

		deps = {@}

		depInTree = (name) ->
			for element in *deps
				if element.name == name
					return true

		depFinder = =>
			dependencies = {}

			for atom in *@buildDependencies
				dependencies[#dependencies+1] = atom

			for atom in *dependencies
				foundOne = false

				-- FIXME: Check if it’s in the distribution’s package manager
				--        if stuff fails.
				for repository in *@context.repositories
					success, r = pcall ->
						@context\openRecipe "#{repository}/#{atom.origin}/package.toml"

					if success
						unless depInTree atom
							ui.debug "Dependency: #{repository}, #{atom}"
							foundOne = true
							deps[#deps+1] = r

							depFinder r

							break

				unless foundOne
					foundOne = isInstalled atom.name

					if foundOne
						ui.debug "Dependency: <installed>, #{atom}"

				unless foundOne
					ui.warning "Dependency not found: '#{atom.name}'."

		depFinder @

		return deps

	__tostring: =>
		if @version
			"<pkgxx:Recipe: #{@name}-#{@version}-#{@release}>"
		else
			"<pkgxx:Recipe: #{@name}-[devel]-#{@release}>"

