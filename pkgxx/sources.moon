
ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

_M = {}

_M.download = (source, context) ->
	fs.changeDirectory context.sourcesDirectory, ->
		module = context.modules[source.protocol]
		if module and module.download
			module.download source
		else
			ui.error "Does not know how to download: #{source.url}"

_M.parse = (recipe) ->
	local sources

	sources = switch type recipe.sources
		when "string"
			{ recipe.sources }
		when "nil"
			{}
		else
			recipe.sources

	for i = 1, #sources
		source = sources[i]
		url = source\gsub " -> .*", ""
		protocol = url\gsub ":.*", ""

		-- Aliases and stuff like git+http.
		protocol = protocol\gsub "+.*", ""
		url = url\gsub ".*+", ""

		sources[i] = {
			protocol: protocol,
			filename: url\gsub ".*/", "",
			url: url
		}

	sources

_M

