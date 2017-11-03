
ui = require "pkgxx.ui"

valueOf = (variable, root, presets) ->
	if root[variable]
		string.gsub root[variable],
			"%%", "%%%%"
	elseif presets[variable]
		string.gsub presets[variable],
			"%%", "%%%%"
	else
		@context\warning "Undefined macro: #{variable}"
		""

parseString = (string, root, presets) ->
	parsed = true

	while parsed
		parsed = false

		for variable in string\gmatch "%%{[a-zA-Z0-9]+}"
			parsed = true
			variable = variable\sub 3, #variable - 1

			string = string\gsub "%%{#{variable}}", "" ..
				valueOf variable, root, presets

		-- Copying that much code is not very elegant.
		for variable in string\gmatch "%%[a-zA-Z0-9]+"
			parsed = true
			variable = variable\sub 2, #variable

			string = string\gsub "%%#{variable}", "" ..
				valueOf variable, root, presets

	string

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
	---
	-- @warning No check is done for circular references.
	parseString: (s, b, p) ->
		parseString s, b, (p or {})
	---
	-- @warning Works destructively.
	parse: (t, b) ->
		parseHelper t, t, b

		return t
}

