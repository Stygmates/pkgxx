
ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

_M = {}

_M.download = (source, context) ->
	fs.changeDirectory context.sourcesDirectory, ->
		if fs.attributes source.filename
			ui.detail "Already downloaded: '#{source.filename}'."
		else
			ui.detail "Downloading '#{source.filename}'."
			os.execute "wget '#{source.url}' -O './#{source.filename}'"

_M

