
--- Package described and built from a Recipe.
--
-- @classmod Package
-- @see Recipe
---

fs = require "pkgxx.fs"
ui = require "pkgxx.ui"
macro = require "pkgxx.macro"

Class = require "pkgxx.class"
Atom = require "pkgxx.atom"

Class
	new: (arg) =>
		@origin = arg.origin

		@name = arg.name

		@dependencies = {}
		@conflicts = {}
		@provides = {}

		@groups = {}
		@options = {}

		@os = arg.os

		-- The “main” package (@name == @origin.name) won’t have those, and
		-- it’s gonna be okay nonetheless.
		@files = arg.files or {}

	__index: (key) =>
		-- The order is: package data, class, recipe data
		(rawget @, key) or @__class[key] or @origin[key]

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
				@@.applyDiff package, os[distribution]

	applyDiff: (diff) =>
		if diff.name
			@name = diff.name
		if diff.version
			@version = diff.version
		if diff.release
			@release = diff.release

		for variable in *{"dependencies", "conflicts", "provides"}
			if diff[variable]
				@[variable] = {}

				for string in *diff[variable]
					table.insert @[variable], Atom string

		if diff.buildDependencies
			for string in *diff.buildDependencies
				table.insert @origin.buildDependencies, Atom string

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

	-- Checks that the package has the files it’s supposed to have in .files.
	package: (module) =>
		if @.automatic and not @\hasFiles!
			ui.debug "Not building automatic package: #{@name}"

			return

		fs.changeDirectory (@\packagingDirectory!), ->
			module.package.build @

	packagingDirectory: =>
		@origin\packagingDirectory @name

	hasOption: (option) =>
		for element in *@options
			if element == option
				return true

		false

	hasFiles: =>
		baseDir = @\packagingDirectory!

		for file in *@files
			filename = baseDir .. "/" .. file

			if not fs.attributes filename
				return false

		true

	__tostring: =>
		if @version
			"<pkgxx:Package: #{@name}-#{@version}-#{@release}>"
		else
			"<pkgxx:Package: #{@name}-[devel]-#{@release}>"

