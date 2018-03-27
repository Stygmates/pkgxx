
Atom = require "pkgxx.atom"

{:map} = require "pkgxx.utils"

class Constraint
	new: (body) =>
		with constraint = self
			-- FIXME: Duplicates (very poorly) the functions of similar names in recipe.moon.
			string = (f) ->
				=>
					if @.type != "declaration"
						error "“#{@.variable}” must be a string!", 0

					f @.value

			array = (f) ->
				=>
					if @.type == "declaration"
						f [i\gsub("^%s*", "")\gsub("%s*$", "") for i in *require("split").split @.value, ","]
					elseif @.type == "list declaration"
						f @.values
					else
						error "“#{@.variable}” must be an array of values!", 0

			fields = {
				-- Conditions.
				"name":                string =>  .name = @
				"flavor":              string =>  .flavor = @
				"class":               string =>  .class = @
				"os":                  string =>  .os = @

				-- Carried values.
				"dependencies":        array  =>  .dependencies = map @, Atom
				"build-dependencies":  array  =>  .buildDependencies = map @, Atom
				"options":             array  =>  .options = @
				"files":               array  =>  .files = @
			}

			for element in *require("pkgxx.spec").parse body
				-- FIXME: Duplicates (very poorly) recipe.moon’s getKey
				key = switch element.type
					when "declaration", "list declaration"
						element.variable
					when "section"
						element.title

				continue unless key

				unless fields[key]
					-- FIXME: No access to recipe right now…
					--recipe.context\debug "[Recipe\\importSpec] unrecognized #{element.type} in section #{element.title} of spec: ”#{key}”."
					continue

				fields[key] element

	__tostring: =>
		s = {}

		for key in *{"name", "flavor", "class", "os", "dependencies", "buildDependencies", "options", "files"}
			if @[key]
				table.insert s, "#{key}=\"#{@[key]}\""

		"<pkgxx:Constraint: #{table.concat s, ", "}>"

