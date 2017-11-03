
ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

{
	download: (source, context) ->
		if fs.attributes source.filename
			context\detail "Already downloaded: '#{source.filename}'."
			return true
		else
			context\detail "Downloading '#{source.filename}'."
			fs.execute {:context}, "wget '#{source.url}' -O './#{source.filename}'"
}

