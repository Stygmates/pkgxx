
ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

{
	download: (source, context) ->
		{:filename, :url} = source

		-- FIXME: Those false ~= are required for Lua 5.1 compatibility.
		--        We need to have some sort of abstraction over Lua’s APIs.
		a = fs.attributes filename
		if a
			ui.detail "Updating local repository for '#{filename}'."
			fs.execute {:context}, "cd '#{filename}' && git pull '#{url}'"
		else
			ui.detail "Cloning repository for '#{filename}'."
			fs.execute {:context}, "git clone '#{url}' '#{filename}'"
	getVersion: (source) ->
		{:filename, :url} = source

		fs.changeDirectory filename, ->
			p = io.popen "git rev-list --count HEAD"
			revision = p\read "*line"
			p\close!

			revision
}

