
ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

{
	download: (source, context) ->
		if fs.attributes source.filename
			ui.detail "Already downloaded: '#{source.filename}'."
			return true
		else
			ui.detail "Downloading '#{source.filename}'."
			fs.execute {:context}, "wget '#{source.url}' -O './#{source.filename}'"
}

