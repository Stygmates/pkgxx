
fs = require "pkgxx.fs"
ui = require "pkgxx.ui"

Class = (arg) ->
	setmetatable arg, {
		__call: (...) =>
			obj = setmetatable {
				__class: arg
			}, {
				__index: arg.__index or arg,
				__tostring: arg.__tostring
			}

			arg.new obj, ...

			obj
	}

Class
	new: (arg) =>
		@origin = arg.origin

		@name = arg.name

		@dependencies = {}
		@buildDependencies = {}
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
		distribution = @context.configuration.distribution
		module = @context.modules[distribution]

		if module
			ui.debug "Distribution: #{module.name}"
			if module.autosplits
				oldIndex = #@splits

				ui.debug "Trying module '#{module.name}'."
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

		for split in *@splits
			os = split.os

			if os and os[distribution]
				@@.applyDiff split, os[distribution]

	guessClass: (split) ->
		if split.name\match "-doc$"
			"documentation"
		elseif split.name\match "-dev$" or split.name\match "-devel$"
			"headers"
		elseif split.name\match "^lib"
			"library"
		else
			"binary"

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

	-- Checks that the split has the files it’s supposed to have in .files.
	package: (module) =>
		if @.automatic and not @origin\splitHasFiles @, @origin\packagingDirectory!
			ui.debug "Not building automatic split: #{@name}"

			return

		fs.changeDirectory (@origin\packagingDirectory @name), ->
			module.package @

	hasOption: (option) =>
		for element in *@options
			if element == option
				return true

		false

	__tostring: =>
		if @version
			"<pkgxx:Split: #{@name}-#{@version}-#{@release}>"
		else
			"<pkgxx:Split: #{@name}-[devel]-#{@release}>"

