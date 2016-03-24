
-- WARNING: works destructively
parseHelper = (t, root, presets) ->
	parsed = true

	while parsed
		parsed = false

		for key, value in pairs t
			switch type value
				when "table"
					parsed = parseHelper value, root
				when "string"
					for variable in value\gmatch "%%{[a-zA-Z0-9]+}"
						variable = variable\sub 3, #variable - 1

						t[key] = value\gsub "%%{#{variable}}",
							tostring (if root[variable]
								string.gsub root[variable], "%%", "%%%%"
							else string.gsub presets[variable], "%%", "%%%%")

						parsed = true

	parsed

{
	-- WARNING: works destructively
	parse: (t, b) ->
		parseHelper t, t, b

		return t
}

