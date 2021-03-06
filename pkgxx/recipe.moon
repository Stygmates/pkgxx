
toml = require "toml"

ui = require "pkgxx.ui"
fs = require "pkgxx.fs"
macro = require "pkgxx.macro"

Source = require "pkgxx.source"
Atom = require "pkgxx.atom"
Package = require "pkgxx.package"
Builder = require "pkgxx.builder"
Constraint = require "pkgxx.constraint"

{:map} = require "pkgxx.utils"

{:split} = require "split"

macroList = =>
	l = {
		pkg: @\packagingDirectory!
	}

	for name in *@context.__class.prefixes
		l[name] = @context\getPrefix name

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

---
-- Operations and data on single recipes.
--
-- It is useful to know that a Recipe can generate multiple packages.
--
-- Recipes are created with one default package, that will inherit most of its properties, including its name, version, and so on.
--
-- @see Package
-- @see Context
-- @see Atom
---
class
	---
	-- Recipe constructor, that’s meant to be used privately only.
	--
	-- To create new Recipe objects, use Context\newRecipe.
	--
	-- @param context (Context) pkgxx Context in which to import the recipe.
	-- @see Context.newRecipe
	new: (context) =>
		--- Context in which the Recipe has been created.
		-- @attribute context
		@context = context
		@packages = {
			Package {
				origin: self
			}
		}

		@constraints = {}

		@buildInstructions = {
			Builder {
				name: "configure"
				critical: false
				context: @context
				recipe: self
			}
			Builder {
				name: "build"
				critical: true
				context: @context
				recipe: self
			}
			Builder {
				name: "install"
				critical: true
				context: @context
				recipe: self
			}
		}

		-- A generic container to pass arbitrary data to modules.
		-- Unknown properties will be stored here, and modules will be
		-- able to access them.
		@recipe = {}

		-- FIXME: This is kept for compatibility reasons with modules.
		--        Should be removed in the future.
		@recipeAttributes = {}

		@sources = {}
		@options = {}

		@groups = {}

		@dependencies = {}
		@buildDependencies = {}
		@conflicts = {}
		@provides = {}

		@versions = {}
		@flavors = {}
	---
	-- Name of the recipe.
	--
	-- @type (string | nil)
	name: nil

	---
	-- Version of the software or content to be packaged.
	--
	-- @type (string | nil)
	version: nil

	---
	-- Version of the recipe itself.
	--
	-- The `release` attribute *should* always be incremented when the recipe is updated.
	--
	-- This attribute *must* have a minimum value of 1 and *must* be an integer.
	--
	-- @type (number)
	release: 1

	---
	-- The person who wrote the recipe.
	--
	-- Should have the following format: `packager name <mail@example>`.
	--
	-- @type (string | nil)
	packager: nil

	---
	-- The person who updates and maintains the recipe.
	--
	-- Recipes imported from `package.toml` files have their maintainer default to `@packager`.
	--
	-- The format of this field is the same as that of `@packager`.
	--
	-- @see packager
	-- @type (string | nil)
	maintainer: nil

	---
	-- Homepage of the packaged project.
	--
	-- @type (string | nil)
	url: nil

	---
	-- List of sources needed to build the recipe and its packages.
	--
	-- Each member of this field *must* be an instance of `Source`.
	--
	-- @see Source
	-- @see addSource
	-- @type (table)
	sources: nil

	---
	-- Instructions to build the software.
	-- 
	-- Contains three fields: `configure`, `build` and `install`, which must all be instances of `Builder`.
	--
	-- @issue Not enough documentation over here~
	--
	-- @type ({configure: Builder, build: Builder, install: Builder})
	-- @see Builder
	buildInstructions: nil

	---
	-- A list of Atoms describing the recipe’s build-time dependencies.
	--
	-- Build-dependencies are shared between all packages described by a recipe.
	--
	-- @see Atom
	-- @type (table)
	buildDependencies: nil

	---
	-- Metadata to check automagically if the recipe is out of date.
	--
	-- @type (table | nil)
	-- @issue There should be a Watch class instead of arbitrary, unchecked tables.
	-- @issue @watch is relatively easy to test… and yet has no test.
	-- @issue A part of it also depends on html-xml-utils or something like that…
	watch: nil

	---
	-- Describes the name of the directory in which the main sources are stored.
	--
	-- This value might be used by modules to configure their build process.
	--
	-- Several default values can be applied during `Recipe\finalize`:
	--
	--   - set to `"#{@name}-#{@version}"` if `@version` exists,
	--   - set to `@name` otherwise.
	--
	-- @type (string | nil)
	dirname: nil

	---
	-- Options with which to build the package.
	--
	-- `.options` is a field of arbitrary strings from which modules can take instructions.
	--
	-- See the various postBuild modules for specific entries to add to the `.options` field.
	--
	-- @type table
	options: nil

	---
	-- Imports a recipe’s data from a package.toml file.
	--
	-- @param filename (string) Filename of the recipe to parse.
	importTOML: (filename) =>
		--- Name of the file from which the recipe has been generated.
		-- @attribute filename
		@filename = filename

		file, reason = io.open filename, "r"

		unless file
			return nil, reason

		recipe, reason = toml.parse (file\read "*all"), {strict: false}

		unless recipe
			return nil, reason

		swapKeys recipe, "build-dependencies", "buildDependencies"

		file\close!

		recipe = macro.parse recipe, macroList @

		@name = recipe.name
		@version = recipe.version
		@release = recipe.release or 1

		@packager = recipe.packager
		@maintainer = recipe.maintainer or @packager
		@url = recipe.url

		@options = recipe.options

		@watch = recipe.watch
		if @watch
			@watch.url = @watch.url or @url

			unless @watch.selector or @watch.lasttar or @watch.execute
				@context\warning "No selector in [watch]. Removing watch."
				@watch = nil

		@dirname = recipe.dirname

		@sources = Source.fromVariable recipe.sources

		do
			bs = recipe["build-system"]
			modules = @context.modules

			instructions = (name) ->
				if modules[recipe[name]]
					modules[recipe[name]]
				elseif modules[bs]
					modules[bs]
				elseif recipe[name]
					recipe[name]

			@buildInstructions[1]\setInstructions instructions "configure"
			@buildInstructions[2]\setInstructions instructions "build"
			@buildInstructions[3]\setInstructions instructions "install"

		@buildDependencies = {}
		for string in *(recipe.buildDependencies or {})
			table.insert @buildDependencies, Atom string

		--- FIXME That field should be removed.
		@recipe = recipe

		-- FIXME: Thas field should be removed.
		@recipeAttributes = fs.attributes filename

		--- Packages described by the recipe.
		-- @attribute packages
		@packages = @\parsePackages recipe or self

		os = recipe.os
		if os and os[@context.distribution]
			distributionRules = os[@context.distribution]
			buildDeps = distributionRules.buildDependencies

			if buildDeps
				@buildDependencies = [Atom(str) for str in *buildDeps]

			if distributionRules.configure
				@buildInstructions[1]\setInstructions distributionRules.configure
			if distributionRules.build
				@buildInstructions[2]\setInstructions distributionRules.build
			if distributionRules.install
				@buildInstructions[3]\setInstructions distributionRules.install

			for package in *@packages
				package\import os[@context.distribution]

		@\finalize!

	importSpec: (filename = "package.spec", version = nil, flavor = nil using nil) =>
		-- CAUTION: Area of intense metaprogramming.
		with recipe = self
			string = (f) ->
				=>
					if @.type != "declaration"
						.context\error "“#{@.variable}” must be a string!"
						return false

					f @.value

			array = (f) ->
				=>
					if @.type == "declaration"
						-- Splitting and trimming.
						f map split(@.value, ","), => @\gsub("^%s*", "")\gsub("%s*$", "")
					elseif @.type == "list declaration"
						f @.values
					else
						.context\error "“#{@.variable}” must be an array of values!"
						return false

			file, reason = io.open filename, "r"

			unless file
				return nil, reason

			spec, reason = require("pkgxx.spec").parse file\read "*all"

			-- Early acquisition of a few values.
			do
				for element in *spec
					switch element.variable
						when "versions"
							@versions = array(=> @) element
						when "flavors"
							@flavors = array(=> @) element

			unless spec
				return nil, reason

			if version
				if has version, @versions
					@version = version
				else
					error "requested version is not specified in recipe", 0
			elseif not @version
				@version = @versions[1]

			if flavor
				if has flavor, @flavors
					@flavor = flavor
				else
					error "requested flavor is not specified in recipe", 0
			elseif not @flavor
				@flavor = @flavors[1]

			variables =
				version: @version
				flavor: @flavor
				pkg: @\packagingDirectory!

			for prefix in *@context.prefixes
				variables[prefix] = @context\getPrefix prefix

			spec, reason = spec\evaluate variables

			unless spec
				return nil, reason

			@recipeAttributes = fs.attributes filename

			getKey = => switch @.type
				when "declaration", "list declaration"
					@.variable
				when "section"
					@.title

			fields = {
				"name":                string =>
				                                  .name = @
				                                  .identifier = @
				"version":             string =>  .version = @
				"release":             string =>  .release = tonumber @ -- FIXME: assert != nil
				"packager":            string =>
				                                  .packager = @
				                                  .maintainer = @ unless .maintainer
				"maintainer":          string =>  .maintainer = @
				"url":                 string =>  .url = @
				"summary":             string =>  .summary = @
				"license":             string =>  .license = @
				"copyright":           string =>  .copyright = @
				"description":         string =>  .description = @
				"class":               string =>  .class = @
				"source":              string =>  .sources = {Source.fromString @}
				"dirname":             string =>  .dirname = @
				"versions":            array  =>  .versions = @ -- May have been parsed already.
				"flavors":             array  =>  .flavors = @  -- May have been parsed already.
				"sources":             array  =>  .sources = map @, Source.fromString
				"dependencies":        array  =>  .dependencies = map @, Atom
				"build-dependencies":  array  =>  .buildDependencies = map @, Atom
				"conflicts":           array  =>  .conflicts = map @, Atom
				"provides":            array  =>  .provides = map @, Atom
				"options":             array  =>  .options = @
				"flags":               array  =>  .context\warning "“flags” is an unimplemented property."
				"slot":                string =>
					if not has @, {"major", "minor"}
						.context\error "“slot” is not “major” or “minor”"

						return false

					.slot = @
			}

			sections = {
				"split": =>
					package = Package origin: recipe

					-- FIXME: A lot of those are redundant with items from “fields”.
					splitFields =
						name:          string =>
						                         package.name = @
						                         package.identifier = @
						files:         array  => package.files = @
						dependencies:  array  => package.dependencies = @
						conflicts:     array  => package.conflicts = @
						provides:      array  => package.provides = @
						options:       array  => package.options = @
						class:         string => package.class = @
						summary:       string => package.summary = @
						description:   string => package.description = @
						license:       string => package.license = @
						copyright:     string => package.copyright = @

					for element in *spec.parse(@.content)\evaluate(recipe)
						unless splitFields[element.variable]
							continue

						splitFields[element.variable] element

					table.insert .packages, package
				"configure": =>   .buildInstructions[1]\setInstructions @.content
				"build": =>       .buildInstructions[2]\setInstructions @.content
				"install": =>     .buildInstructions[3]\setInstructions @.content
				"watch": =>
					-- FIXME: It’s time to have a dedicated Watch class.
					section = spec.parse(@.content)\evaluate!

					watch = {}

					watchFields =
						url:      string => watch.url = @
						selector: string => watch.selector = @
						lasttar:  string => watch.lasttar = @
						execute:  string => watch.execute = @
						subs:     array  => watch.subs = @

					for element in *section
						if element.type == "declaration" or element.type == "list declaration"
							unless watchFields[element.variable]
								continue

							watchFields[element.variable] element

					.watch, error = require("pkgxx.watch").fromSpec watch

					for warning in *.watch.warnings
						.context\warning warning

					unless .watch
						.context\error error

				"constraint": =>
					success, constraint = pcall -> Constraint @.content

					if success
						table.insert .constraints, constraint
					else
						.context\error constraint
			}

			things = {
				"declaration": fields
				"list declaration": fields
				"section": sections
			}

			for element in *spec
				key = getKey element

				continue unless key

				list = things[element.type]

				unless list[key]
					switch element.type
						when "declaration"
							@recipe[key] = element.value
						when "list declaration"
							@recipe[key] = element.values
						else
							.context\debug "[Recipe\\importSpec] unrecognized #{element.type} in spec: “#{key}”"

					continue

				r = list[key] element

				if r == false
					return nil, "An error occured while reading the spec file."

		@\finalize!

	---
	-- Adds sources to the Recipe.
	--
	-- If the sources are provided as a URL, they will automatically be converted to a Source.
	-- The arrow notation (url -> filename) is supported if you want or need to name the downloaded file.
	--
	-- @param source (string | Source) URL or Source that describes the sources to add.
	--
	-- @return (true) All clear.
	-- @return (nil, string) Source parsing error or filename collision.
	addSource: (source) =>
		if type(source) == "string"
			source = Source.fromString source

		for s in *@sources
			if s.filename == source.filename
				return nil, "filename already used by another source"

		table.insert @sources, source

		true

	---
	-- Defines a new Package in the recipe.
	--
	-- @param name (string) The `name` attribute of the Package to create.
	-- @return (Package) The newly created Package.
	addPackage: (name) =>
		package = Package {
			origin: self
			:name
		}

		table.insert @packages, package

		package

	---
	-- Finalizes a recipe and makes it ready for use.
	--
	-- All missing or uninitialized attributes will be set to safe values for further operations.
	--
	-- Recipes *must* be finalized before calling @{Recipe\build} or @{Recipe\package}.
	--
	-- @return nil
	finalize: =>
		unless @name
			return nil, "cannot finalize a recipe without @name"

		@release or= 1
		@sources or= {}
		@buildDependencies or= {}

		@dirname or= if @version
			"#{@name}-#{@version}"
		else
			@name

		-- @watch guess.
		-- Is done very long after the possible static definition of watch because modules may need to have access to other values.
		unless @watch
			for _, module in pairs @context.modules
				if module.watch
					with watch = module.watch self
						if watch
							-- FIXME: Maybe we could do some additionnal checks.
							@watch = watch

		-- Slots \o/ (for package managers that don’t support it)
		if @slot
			for package in *@packages
				package\applySlot!

		@\applyDistributionRules @recipe or self

		-- Importing packages’ dependencies in the build-deps.
		for package in *@packages
			for atom in *package.dependencies
				if not has atom, @buildDependencies
					@buildDependencies[#@buildDependencies+1] = atom

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

		@\setTargets!

		@\checkRecipe!

		true

	--- @hidden
	-- FIXME: This should probably be moved to macro, or at least somewhat overhauled.
	parse: (string) =>
		parsed = true
		while parsed
			string, parsed = macro.parseString string, (macroList @), @

		string

	--- @hidden
	-- Used internally.
	--
	-- Is meant to be usable after package manager or architecture
	-- changes, avoiding the creation of a new context.
	setTargets: =>
		--- @fixme Will be removed.
		module = @context.modules[@context.packageManager]

		unless module and module.package
			@context\error "Could not set targets. Wrong package manager module?"
			return nil

		for package in *@packages
			package\updateTarget @context

		@target = @packages[1].target

	---
	-- Lists the filenames and packages this recipe defines.
	--
	-- @return (function) Iterator over the pairs of filename and Package defined by the Recipe.
	-- @see Package
	getTargets: =>
		--- @fixme Will be removed. Use `ipairs recipe.packages`.
		i = 1

		return ->
			i = i + 1

			if i - 1 <= #@packages
				package = @packages[i - 1]

				return package.target, package

	---
	-- @return (string) Location of the recipe’s log file.
	-- @deprecated
	getLogFile: => @context.logFilePath

	--- @hidden
	-- FIXME: The package.toml specific code should just move somewhere else.
	parsePackages: (recipe) =>
		packages = {}

		packages[1] = Package
			name: @name
			origin: @

		packages[1]\import recipe

		if recipe.splits
			for _, data in ipairs recipe.splits
				-- Packages will need much more data than this.
				-- FIXME: Package!? Target!?
				print data.name
				package = Package
					name: data.name
					identifier: data.name
					origin: @
					os: data.os
					files: data.files

				package\import data

				package.class = package.class or package\guessClass!

				packages[#packages+1] = package

		packages

	--- @hidden
	-- Hidden until semantics clarification and lots of grooming.
	-- FIXME: Review and test intensively. Shouldn’t more Constraints
	--        types be checked?
	applyDistributionDiffs: (recipe, distribution) =>
		if recipe.os
			for name, content in pairs recipe.os
				table.insert @constraints, Constraint with content
					.os = name

	--- @hidden
	-- Hidden until semantics clarification and lots of grooming.
	applyDistributionRules: (recipe) =>
		distribution = @context.distribution
		module = @context.modules[distribution]

		@\applyDistributionDiffs recipe, distribution

		if module
			@context\debug "Distribution: #{module.name}"

			for package in *@packages
				if module.alterRecipe
					module.alterRecipe package, recipe

			if module.autosplits
				@context\debug "Trying module '#{module.name}'."
				for data in *module.autosplits @
					if not @\hasPackage data.name
						@context\debug "Registering automatic package: #{package.name}."
						table.insert @packages, Package with data
							.files = macro.parse (.files or {}), macroList @
							.automatic = true
							.origin = @
		else
			@context\warning "No module found for this distribution: " ..
				"'#{distribution}'."
			@context\warning "Your package is unlikely to comply to " ..
				"your OS’ packaging guidelines."

	--- @hidden
	-- FIXME: remove
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

	---
	-- Checks that a Recipe defines a Package.
	--
	-- @param name (string) Name of the package.
	-- @return (boolean) Whether the Recipe contains a Package with the given name or not.
	--
	-- @info Will probably get patched to identify Packages based on an Atom and not just a name string.
	hasPackage: (name) =>
		for package in *@packages
			if package.name == name
				return true

		false

	--- @hidden
	-- Used during build.
	-- Hidden until semantics clarification and lots of grooming.
	postBuildHooks: =>
		for module in *@context.modules
			if module.postBuild
				fs.directory @\packagingDirectory!, ->
					module.postBuild @

	---
	-- @return (string) The directory in which the software will be built.
	buildingDirectory: =>
		"#{@context.buildingDirectory}/src/" ..
			"#{@name}-#{@version}-#{@release}"

	---
	-- @return (string) The “fake installation root” of the package, as used during build.
	packagingDirectory: (name) =>
		unless name
			name = "_"

		"#{@context.buildingDirectory}/pkg/#{name}"

	---
	-- Checks whether the recipe’s packages need updating or rebuilding.
	--
	-- @return (true)  Recipe needs rebuild.
	-- @return (false) Everything is up to date.
	buildNeeded: =>
		for self in *self.packages
			if self.automatic
				continue

			attributes = fs.attributes "" ..
				"#{@context.packagesDirectory}/#{@target}"
			unless attributes
				return true

			if attributes.modification < @recipeAttributes.modification
				@context\info "Recipe is newer than packages."
				return true

		false

	---
	-- Checks whether the recipe’s dependencies and build-dependencies are installed, and tries to install them if they are not.
	--
	-- @return nil
	checkDependencies: =>
		@context\info "Checking dependencies…"

		deps = {}
		for atom in *@buildDependencies
			table.insert deps, atom

		for atom in *deps
			unless @context\isAtomInstalled atom
				-- FIXME: Check the configuration to make sure it’s tolerated.
				--        If it isn’t, at least ask interactively.
				@context\detail "Installing missing dependency: #{atom.name}"
				@\installDependency atom.name

	---
	-- Installs a package by name.
	--
	-- @param name (string) Name of the package to install.
	-- @issue Will be moved to Context at some point.
	installDependency: (name) =>
		-- @fixme Should probably be in Context. =/
		module = @context.modules[@context.dependenciesManager]
		if not (module and module.installDependency)
			module = @context.modules[@context.packageManager]

		if not (module and module.installDependency)
			return nil, "no way to install packages"

		module.installDependency @context, name

	---
	-- Downloads the recipe’s sources.
	--
	-- @return (boolean) Boolean indicating whether or not the downloads succeeded.
	download: =>
		@context\info "Downloading…"

		for source in *@sources
			if (source\download @context) ~= true
				return false

		true

	---
	-- Generates the recipe’s version from its sources.
	--
	-- Is useless for recipes with static versions, but is useful if a recipe is of a development version from a git repository or any similar situation.
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

	--- @hidden
	-- Hidden until clarified semantics and some grooming.
	prepareBuild: =>
		fs.mkdir @\buildingDirectory!
		fs.mkdir @\packagingDirectory!

		for package in *@packages
			fs.mkdir @\packagingDirectory package.name

	--- @hidden
	-- Hidden until clarified semantics and some grooming.
	extract: =>
		@context\info "Extracting…"

		fs.changeDirectory @\buildingDirectory!, ->
			for source in *@sources
				if source.filename\match "%.tar%.[a-z0-9]*$"
					@context\detail "Extracting '#{source.filename}'."
					os.execute "tar xf " ..
						"'#{@context.sourcesDirectory}/" ..
						"#{source.filename}'"
				else
					@context\detail "Copying '#{source.filename}'."
					-- FIXME: -r was needed for repositories and stuff.
					--        We need to modularize “extractions”.
					os.execute "cp -r " ..
						"'#{@context.sourcesDirectory}/" ..
						"#{source.filename}' ./"

	---
	-- Builds the recipe.
	--
	-- This method does not build the packages themselves.
	-- The `package` method does that.
	--
	-- @see Package
	-- @see Recipe\package
	-- @see Recipe\finalize
	build: =>
		--- @warning \finalize! must have been called first.
		@\prepareBuild!

		@\extract!

		@context\info "Building…"

		for step, builder in ipairs @buildInstructions
			success, e = builder\execute!

			unless success
				if builder.critical
					return nil, e
				elseif e
					@context\warning e

		@context\info "Doing post-build verifications."
		@\postBuildHooks!

		true

	--- @hidden
	-- Hidden until clarified semantics and moderate amounts of grooming.
	split: =>
		for package in *@packages
			if package.files
				if package.automatic and not package\hasFiles!
					@context\debug "No file detected for #{package.name}. Ignoring."
					continue

				package\moveFiles!

		-- FIXME: A bit hacky. We need packaging directories and fake roots
		--        to be different.
		fs.remove @\packagingDirectory @packages[1].identifier
		fs.execute @, "mv '#{@\packagingDirectory!}' " ..
			"'#{@\packagingDirectory @packages[1].identifier}'"

	---
	-- Creates packages from the built software.
	-- @see Recipe\build
	-- @see Recipe\finalize
	package: =>
		--- @warning \finalize! must have been called first.
		@context\info "Packaging…"
		@\split!

		module = @context.modules[@context.packageManager]

		if module.package
			for package in *@packages
				package = package\createConstrainedPackage @

				if package.automatic and not package\hasFiles!
					@context\debug "Not building (empty) automatic package: #{package.name}"
					continue

				unless package\package module
					return nil

			return true
		else
			-- Should NOT happen.
			error "No module is available for the package manager "..
				"'#{@context.packageManager}'."

	---
	-- Removes the recipe’s temporary building directories.
	--
	-- @return (boolean) Whether removing the files succeeded or not.
	clean: =>
		@context\info "Cleaning…"
		@context\detail "Removing '#{@\buildingDirectory!}'."

		-- Sort of necessary, considering the directories and files are
		-- root-owned. And they have to if we want our packages to be valid.
		os.execute "sudo rm -rf '#{@\buildingDirectory!}'"

	---
	-- Prints potential defects or missing data in the recipe.
	--
	-- It prints the defects themselves on stderr, and returns the number of defects found.
	--
	-- @return (number) Number of defects found in the recipe’s current configuration.
	lint: =>
		e = 0

		unless @name
			@context\error "no 'name' field"
			e = e + 1
		unless @sources
			@context\error "no 'sources' field"
			e = e + 1

		unless @version
			isVersionable = false

			for source in *@sources
				m = @context.modules[source.protocol]

				if m and m.getVersion
					isVersionable = true

					break

			unless isVersionable
				@context\error "no 'version' field"
				e = e + 1

		unless @url
			@context\warning "no 'url' field"
			e = e + 1

		unless @packager
			@context\warning "no 'packager' field"
			e = e + 1

		unless @watch
			@context\warning "no 'watch' section"
		else
			with @watch
				unless .selector or .lasttar or .execute
					@context\warning "unusable 'watch', needs a selector, " ..
						"lasttar or execute field"

		for package in *@packages
			with self = package
				@context\detail tostring @name
				unless @summary
					@context\warning "no 'summary' field"
					e = e + 1
				unless @description
					@context\warning "no 'description' field"
					e = e + 1

				unless @options
					@context\warning "no 'options' field"
					e = e + 1

				unless @dependencies
					@context\warning "no 'dependencies' field"
					e = e + 1

		e

	---
	-- Checks whether or not the recipe is up to date.
	--
	-- It may need access to recent sources to do so.
	--
	-- @see Recipe\download
	--
	-- @return (true, string) Version is up to date. Also returns the version.
	-- @return (false, string) Recipe is outdated. Returns the latest version available.
	isUpToDate: =>
		if @watch
			latestVersion = @watch\getLatestVersion @context
		(@watch\isUpToDate @) if @watch

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
				@context\warning "Unable to determine installed dependencies."

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

				for repository in *@context.repositories
					success, r = pcall ->
						@context\openRecipe "#{repository}/#{atom.origin}/package.toml"

					if success
						unless depInTree atom
							@context\debug "Dependency: #{repository}, #{atom}"
							foundOne = true
							deps[#deps+1] = r

							depFinder r

							break

				unless foundOne
					foundOne = isInstalled @context, atom.name

					if foundOne
						@context\debug "Dependency: <installed>, #{atom}"

				unless foundOne
					@context\warning "Dependency not found: '#{atom.name}'."

		depFinder @

		return deps

	---
	-- Recipe can be safely converted to a debug string.
	__tostring: =>
		if @version
			"<pkgxx:Recipe: #{@name}-#{@version}-#{@release}>"
		else
			"<pkgxx:Recipe: #{@name}-[devel]-#{@release}>"

