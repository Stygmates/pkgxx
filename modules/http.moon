
ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

{
	download: (source) ->
		if fs.attributes source.filename
			ui.detail "Already downloaded: '#{source.filename}'."
			return true
		else
			ui.detail "Downloading '#{source.filename}'."
			os.execute "wget '#{source.url}' -O './#{source.filename}'"
}

