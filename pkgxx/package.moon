
--- Package described and built from a Recipe.
--
-- Packages dynamically inherit most of their attributes from their Recipe.
-- As a consequence, a way to easily share values between packages is to put them inside their common Recipe.
--
-- @classmod Package
-- @see Recipe
-- @see Atom
---

fs = require "pkgxx.fs"
ui = require "pkgxx.ui"
macro = require "pkgxx.macro"

Class = require "pkgxx.class"
Atom = require "pkgxx.atom"

--- Name of the package.
-- @attribute name

--- Version of the packaged software or content.
-- @attribute version

--- Version of the package or its recipe.
-- @attribute release

--- Short (one-line) description of the packaged software or content.
-- @attribute summary

--- Long (multi-line) description of the packaged software or content.
-- @attribute description

--- Dependencies the package needs to be installed.
-- @attribute dependencies

--- Packages that must not be installed at the same time as the generated package.
-- @attribute conflicts

--- Virtual packages that this package will provide.
-- @attribute provides

--- Legacy options for some RPM distributions.
-- @attribute groups

--- Generic options field for build and packaging modules.
-- @attribute options

--- List of files that will have to be taken from the fake installation root of the recipe and saved into this package.
-- The recipe’s first package will have an empty list of files, as it will take any file not taken by another package.
-- @attribute files

---
-- Constructor.
--
-- @function __init
-- @tparam table arg
-- @tparam Recipe arg.origin
-- @tparam string arg.name
-- @tparam table  arg.files
-- @tparam string arg.files.1
Class
	__init: (arg) =>
		--- @fixme Constructor’s documentation is in the wrong place because LDoc is broken.
		@origin = arg.origin
		@name = arg.name

		@dependencies = {}
		@conflicts = {}
		@provides = {}

		@groups = {}

		@options = {}

		@files = arg.files or {}

	---
	-- Imports values from another object.
	--
	-- @tparam table     data A list of named parameters.
	-- @tparam string    data.name New name of the package.
	-- @tparam string    data.version Version of the packaged software.
	-- @tparam integer   data.release Version of the package.
	-- @tparam table     data.dependencies A list of Atoms representing the package’s dependencies.
	-- @tparam Atom      data.dependencies.1
	-- @tparam table     data.conflicts A list of conflicts for this package.
	-- @tparam Atom      data.conflicts.1
	-- @tparam table     data.provides A list of virtual packages provided.
	-- @tparam Atom      data.provides.1
	-- @tparam table     data.buildDependencies A list of build-time dependencies needed for this package and its recipe.
	-- @tparam Atom      data.buildDependencies.1
	-- @tparam table     data.groups Legacy option for old RPMs.
	-- @tparam string    data.groups.1
	-- @tparam table     data.options A list of options to pass to pkgxx modules.
	-- @tparam string    data.summary Short description of the packaged software.
	-- @tparam string    data.description Long description of the packaged software.
	-- @tparam string    data.license License of the packaged software.
	-- @tparam string    data.copyright One-line copyright statement to generate debian/copyright.
	-- @tparam string    data.class Package class.
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

	applyDistributionRules: (recipe) =>
		distribution = @context.distribution
		module = @context.modules[distribution]

		if module
			ui.debug "Distribution: #{module.name}"
			if module.autosplits
				ui.debug "Trying module '#{module.name}'."
				newPackages = module.autosplits @
				newPackages = macro.parse newPackages, macroList @

				for package in *@\parsePackages splits: newPackages
					ui.debug "Registering automatic package: #{package.name}."

					-- FIXME: Some of that code seems copied from Recipe.
					--        Copying code is bad. But it might also be broken.
					if not @\hasPackage package.name
						package.automatic = true
						@packages[#@packages+1] = package
					else
						ui.debug " ... package already exists."
		else
			ui.warning "No module found for this distribution: " ..
				"'#{distribution}'."
			ui.warning "Your package is very unlike to comply to " ..
				"your OS’ packaging guidelines."

		for package in *@packages
			os = package.os

			if os and os[distribution]
				@@.import package, os[distribution]

	moveFiles: =>
		ui.detail "Packageting '#{@name}'."

		for file in *@files
			source = (@origin\packagingDirectory "_") .. file
			destination = (@\packagingDirectory!) .. file
			ui.debug "package: #{source} -> #{destination}"

			-- XXX: We need to be more cautious about
			--      permissions here.
			if fs.attributes source
				fs.mkdir destination\gsub "/[^/]*$", ""
				os.execute "mv '#{source}' '#{destination}'"

	---
	-- Creates a package using the package manager module passed as parameter.
	--
	-- Checks that the package has the files it’s supposed to have in .files.
	--
	-- @tparam table module Package manager module.
	package: (module) =>
		if @.automatic and not @\hasFiles!
			ui.debug "Not building automatic package: #{@name}"

			return

		fs.changeDirectory (@\packagingDirectory!), ->
			module.package.build @

	packagingDirectory: =>
		@origin\packagingDirectory @name

	--- Checks the Package possesses any specific option.
	-- @tparam string option Any arbitrary package option.
	-- @treturn boolean Whether the package has the given option or not.
	-- @see Package.options
	hasOption: (option) =>
		for element in *@options
			if element == option
				return true

		false

	---
	-- Indicates whether the package is empty or not.
	--
	-- This method is meant to be used after Recipe\build has been called.
	--
	-- @treturn boolean Whether the Package would be built with any file at all.
	-- @see Recipe\build
	hasFiles: =>
		baseDir = @\packagingDirectory!

		for file in *@files
			filename = baseDir .. "/" .. file

			if not fs.attributes filename
				return false

		true

	---
	-- Dynamic inheritance that obtains missing attributes or methods in `@recipe`.
	-- @see Recipe
	-- @tparam variable key
	__index: (key) =>
		-- The order is: package data, class, recipe data
		rawget(@, key) or getmetatable(self)[key] or rawget(self, "origin")[key]

	---
	-- Package can be transformed to a string for debug operations.
	__tostring: =>
		if @version
			"<pkgxx:Package: #{@name}-#{@version}-#{@release}>"
		else
			"<pkgxx:Package: #{@name}-[devel]-#{@release}>"

