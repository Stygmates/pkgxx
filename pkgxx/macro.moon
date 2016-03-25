
ui = require "pkgxx.ui"

-- WARNING: works destructively
parseHelper = (t, root, presets) ->
	parsed = true

	while parsed
		parsed = false

		for key, value in pairs t
			switch type value
				when "table"
					parsed = parseHelper value, root, presets
				when "string"
					for variable in value\gmatch "%%{[a-zA-Z0-9]+}"
						variable = variable\sub 3, #variable - 1

						t[key] = value\gsub "%%{#{variable}}", "" ..
							if root[variable]
								string.gsub root[variable],
									"%%", "%%%%"
							elseif presets[variable]
								string.gsub presets[variable],
									"%%", "%%%%"
							else
								ui.warning "Undefined macro: #{variable}"
								""

						parsed = true

	parsed

{
	-- WARNING: works destructively
	parse: (t, b) ->
		parseHelper t, t, b

		return t
}

