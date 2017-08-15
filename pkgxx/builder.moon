
Class = require "pkgxx.class"

fs = require "pkgxx.fs"

Class "Builder",
	__init: (arg) =>
		@name = arg.name
		@context = arg.context
		@recipe = arg.recipe

		if arg.instructions
			@\setInstructions arg.instructions

		@critical = if arg.critical == nil
			true
		else
			arg.critical

	__tostring: =>
		"<Builder: #{@name}>"

	---
	-- @todo No checking is currently done concerning the quality of the provided instructions.
	-- @tparam variable instructions
	setInstructions: (instructions) =>
		@instructions = instructions

	execute: =>
		exec = switch type(@instructions)
			when "table"
				code = table.concat @instructions, "\n"
				code = "set -x\n#{code}"

				-> return fs.execute self, code
			when "string"
				-> return fs.execute self, @instructions
			when "function"
				-> return @instructions @recipe
			when "nil"
				-- Guessing stuff, duh~
				module = @\guessModule!

				if module
					-> module[@name] @recipe
				else
					return nil, "Could not find module."
			else
				return nil, "Builder cannot execute #{type(@instructions)}."

		fs.changeDirectory @recipe\buildingDirectory!, exec

	guessModule: =>
		guessFunctionName = "can" .. @name\sub(1, 1)\upper! .. @name\sub(2, #@name)

		for _, module in pairs @context.modules
			test = module[guessFunctionName]

			unless test
				continue

			r = fs.changeDirectory @recipe\buildingDirectory!, ->
				test @recipe

			unless r
				continue

			return module


