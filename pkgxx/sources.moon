
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

_M

