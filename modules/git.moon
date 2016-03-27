
ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

{
	download: (source) ->
		{:filename, :url} = source

		a = fs.attributes filename
		if a
			ui.detail "Updating local repository for '#{filename}'."
			os.execute "cd '#{filename}' && git pull '#{url}'"
		else
			ui.detail "Cloning repository for '#{filename}'."
			os.execute "git clone '#{url}' '#{filename}'"
	getVersion: (source) ->
		{:filename, :url} = source

		fs.changeDirectory filename, ->
			p = io.popen "git rev-list --count HEAD"
			revision = p\read "*line"
			p\close!

			revision
}

