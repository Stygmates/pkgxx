
ui = require "pkgxx.ui"

-- FIXME: Check for circular references.
parseString = (string, root, presets) ->
	parsed = false

	for variable in string\gmatch "%%{[a-zA-Z0-9]+}"
		parsed = true
		variable = variable\sub 3, #variable - 1

		string = string\gsub "%%{#{variable}}", "" ..
			if root[variable]
				string.gsub root[variable],
					"%%", "%%%%"
			elseif presets[variable]
				string.gsub presets[variable],
					"%%", "%%%%"
			else
				ui.warning "Undefined macro: #{variable}"
				""

	string, parsed

-- FIXME: Works destructively.
parseHelper = (t, root, presets) ->
	parsed = true

	while parsed
		parsed = false

		for key, value in pairs t
			switch type value
				when "table"
					parsed = parseHelper value, root, presets
				when "string"
					t[key], parsed = parseString value, root, presets

	parsed

{
	-- FIXME: Works destructively.
	parseString: parseString,
	parse: (t, b) ->
		parseHelper t, t, b

		return t
}

