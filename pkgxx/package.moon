
fs = require "pkgxx.fs"
ui = require "pkgxx.ui"
macro = require "pkgxx.macro"

Class = require "pkgxx.class"
Atom = require "pkgxx.atom"

local Package

---
-- Package described and built from a Recipe.
--
-- Packages dynamically inherit most of their attributes from their Recipe.
-- As a consequence, a way to easily share values between packages is to put them inside their common Recipe.
--
-- @see Recipe
-- @see Atom
---
Package = Class "Package",
	---
	-- Constructor.
	--
	-- Takes an array of named parameters to set attributes during construction.
	-- Example below.
	--
	-- ```
	-- Package
	--   origin: some_recipe -- Recipe object
	--   name: "hello-bin"
	--   files: {"/usr/bin/hello"}
	-- ```
	--
	-- @param arg (table) Array of named parameters.
	__init: (arg) =>
		@origin = arg.origin
		@name = arg.name
		@identifier = arg.identifier or arg.name

		@automatic = arg.automatic or false

		@dependencies = @origin.dependencies
		@conflicts = @origin.conflicts
		@provides = @origin.provides

		@groups = @origin.groups

		@options = @origin.options

		@files = arg.files or {}

	---
	-- Package’s name.
	-- @type (string | nil)
	name: nil

	---
	-- Version of the packaged software or content.
	--
	-- @type (string | nil)
	version: nil

	---
	-- Version of the package’s recipe itself.
	--
	-- `@release` must *always* be an integer.
	-- Its minimum legal value is 1.
	--
	-- @warning This field might be removed from Package and left to inherit from its `@origin` Recipe.
	-- @type (number)
	release: 1


	---
	-- Short (one-line) description of the packaged software or content.
	--
	-- @type (string | nil)
	summary: nil

	---
	-- Long (multi-line) description of the packaged software or content.
	--
	-- @type (string | nil)
	description: nil

	---
	-- Dependencies the package needs to be installed.
	--
	-- @type (table)
	dependencies: nil

	---
	-- Packages that must not be installed at the same time as the generated package.
	--
	-- @type (table)
	conflicts: nil

	---
	-- Virtual packages that this package will provide.
	--
	-- @type (table)
	provides: nil

	---
	-- Generic options field for build and packaging modules.
	--
	-- @type (table)
	options: nil

	---
	-- Legacy options for some RPM-based distributions.
	--
	-- @warning This option will probably never be used anymore, and might get removed in the future. Send an issue if you need its feature.
	-- @type (table)
	groups: nil

	---
	-- List of files that will have to be taken from the fake installation root of the recipe and saved into this package.
	-- The recipe’s first package will have an empty list of files, as it will take any file not taken by another package.
	--
	-- The files are represented by paths relative to their fake installation root.
	--
	-- @type (table)
	files: nil

	---
	-- Imports values from another object.
	--
	-- #### `arg` fields
	--
	-- type    | field              | description
	-- --------|--------------------|------------------------------------------
	-- string  | name               | New name of the package.
	-- string  | version            | Version of the packaged software.
	-- integer | release            | Version of the package.
	-- table   | dependencies       | A list of Atoms representing the package’s dependencies.
	-- table   | conflicts          | A list of conflicts for this package.
	-- table   | provides           | A list of virtual packages provided.
	-- table   | buildDependencies  | A list of build-time dependencies needed for this package and its recipe.
	-- table   | groups             | Legacy option for old RPMs.
	-- table   | options            | A list of options to pass to pkgxx modules.
	-- string  | summary            | Short description of the packaged software.
	-- string  | description        | Long description of the packaged software.
	-- string  | license            | License of the packaged software.
	-- string  | copyright          | One-line copyright statement to generate debian/copyright.
	-- string  | class              | Package class.
	--
	-- @return nil
	import: (data) =>
		if data.name
			@name = data.name
		if data.version
			@version = data.version
		if data.release
			@release = data.release

		for variable in *{"dependencies", "conflicts", "provides"}
			if data[variable]
				@[variable] = {}

				for string in *data[variable]
					table.insert @[variable], Atom string

		if data.buildDependencies
			for string in *data.buildDependencies
				table.insert @origin.buildDependencies, Atom string

		if data.groups
			@groups = data.groups
		if data.options
			@options = data.options

		if data.summary
			@summary = data.summary
		if data.description
			@description = data.description

		if data.license
			@license = data.license
		if data.copyright
			@copyright = data.copyright

		if data.class
			@class = data.class

	---
	-- Looks like it does some automated splitting and other distro-related checks.
	-- Also applies diffs.
	--
	-- @hidden Not really publicly usable for now. Needs a well-defined behavior.
	applyDistributionRules: (recipe) =>
		distribution = @context.distribution
		module = @context.modules[distribution]

		if module
			if module.autosplits
				@context\debug "Trying module '#{module.name}'."
				newPackages = module.autosplits @
				newPackages = macro.parse newPackages, macroList @

				for package in *@\parsePackages splits: newPackages
					@context\debug "Registering automatic package: #{package.name}."

					-- FIXME: Some of that code seems copied from Recipe.
					--        Copying code is bad. But it might also be broken.
					if not @\hasPackage package.name
						package.automatic = true
						@packages[#@packages+1] = package
					else
						@context\debug " ... package already exists."
		else
			@context\warning "No module found for this distribution: " ..
				"'#{distribution}'."
			@context\warning "Your package is very unlike to comply to " ..
				"your OS’ packaging guidelines."

		for package in *@packages
			os = package.os

			if os and os[distribution]
				@@.import package, os[distribution]

	---
	-- Creates a new Package that hase the same properties and on
	-- which a Recipe’s set of constraints have been applied (if
	-- relevant).
	--
	-- FIXME: May not be practical to generate distro or arch-specific
	--        sets of packages. Pass a context in args? Pass os and
	--        stuff directly?
	createConstrainedPackage: (recipe) =>
		keys = {
			"name", "dependencies", "buildDependencies",
			"provides", "conflicts", "options",
			"files"
		}

		package = Package @

		-- Generic constraints.
		for constraint in *recipe.constraints
			if constraint\appliesTo @, recipe.context
				if constraint.name
					for key in *keys
						if constraint[key]
							package[key] = constraint[key]

		package\updateTarget recipe.context

		package

	applySlot: =>
		pattern = switch @slot
			when "major"
				"%d"
			when "minor"
				"%d%.%d"
			else -- Should probably not happen.
				@slot

		slotVersion = @version\match pattern

		packageManager = @context.modules[@context.packageManager]

		if packageManager.package.handleSlot
			packageManager.package.handleSlot @, slotVersion

	updateTarget: (context) =>
		-- We’re assuming it exists at this point.
		-- Recipe\setTargets should have made the check already.
		module = @context.modules[@context.packageManager]

		@target = module.package.target @

		@target

	---
	-- Prepares files for splits, by moving them from the main packaging directory to those of their respective splits.
	-- @issue Should be renamed. That name is not representative of what it does in any way.
	-- @hidden
	moveFiles: =>
		@context\detail "Packageting '#{@name}'."

		for file in *@files
			source = (@origin\packagingDirectory "_") .. file
			destination = (@\packagingDirectory!) .. file
			@context\debug "package: #{source} -> #{destination}"

			-- XXX: We need to be more cautious about
			--      permissions here.
			if fs.attributes source
				fs.mkdir destination\gsub "/[^/]*$", ""
				os.execute "mv '#{source}' '#{destination}'"

	---
	-- Creates a package using the package manager module passed as parameter.
	--
	-- Checks that the package has the files it’s supposed to have in `@files`.
	--
	-- @param module (Module) Package manager module.
	-- @return true | nil, string
	package: (module) =>
		hasFiles, missingFile = @\hasFiles!

		unless hasFiles
			@context\error "Some files could not be split properly for package '#{@name}'"
			@context\detail "Missing file: #{missingFile}"

			return

		fs.changeDirectory (@\packagingDirectory!), ->
			module.package.build @

	---
	-- @return (string) The directory this package will be built in.
	-- @see Recipe\packagingDirectory
	packagingDirectory: =>
		@origin\packagingDirectory @identifier

	---
	-- Checks the Package possesses any specific option.
	--
	-- @param option (string) Any arbitrary package option.
	-- @return (boolean) Whether the package has the given option or not.
	--
	-- @see Package.options
	hasOption: (option) =>
		for element in *@options
			if element == option
				return true

		false

	---
	-- Indicates whether the package’s expected files have been built or not.
	--
	-- This method is meant to be used after Recipe\build has been called.
	--
	-- @return (boolean) Whether the Package can be build with all of its files.
	--
	-- @see Recipe\build
	hasFiles: =>
		baseDir = @\packagingDirectory!

		for file in *@files
			filename = baseDir .. "/" .. file

			if not fs.attributes filename
				return false, filename

		true

	---
	-- Dynamic inheritance that obtains missing attributes or methods in `@recipe`.
	--
	-- The order in which values are accessed is the following: self, class, origin (Recipe).
	--
	-- @see Recipe
	-- @param key (object)
	__index: (key) =>
		-- The order is: package data, class, recipe data
		rawget(@, key) or getmetatable(self)[key] or rawget(self, "origin")[key]

	---
	-- Package can be transformed to a string for debug operations.
	__tostring: =>
		if @version
			"<pkgxx:Package: #{@identifier}-#{@version}-#{@release}>"
		else
			"<pkgxx:Package: #{@identifier}-[devel]-#{@release}>"

Package

