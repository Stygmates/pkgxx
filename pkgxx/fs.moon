
ui = require "pkgxx.ui"
lfs = require "lfs"

unpack = unpack or table.unpack

{
	mkdir: (dir) ->
		local path

		if dir\match "^/"
			path = "/"

		for name in dir\gmatch "[^/]+"
			if path
				path = path .. "/" .. name
			else
				path = name

			lfs.mkdir path

	remove: (filename, options) ->
		-- FIXME: use lfs
		opt = ""

		for option, value in pairs (options or {})
			switch option
				when "force"
					if value
						opt = opt .. " -f"
				else
					print "ERROR: unsupported option: #{option}=#{value}"

		os.execute "rm -r #{opt} '#{filename}'"

	-- That particular function is hell. Please add debugging stuff
	-- to it.
	changeDirectory: (newDir, f) ->
		oldDir = lfs.currentdir!

		r, e = lfs.chdir newDir
		if r
			r = {f!}
			lfs.chdir oldDir

			return unpack r
		else
			error e

	currentDirectory: lfs.currentdir,

	attributes: lfs.attributes,
	dir: lfs.dir,

	execute: (arg) =>
		arg = "set -e; " .. arg
		exports = ""

		for key, value in pairs @context.exports
			exports = exports .. "export #{key}='#{value}';"

		if ui.getVerbosity! < 6
			logfile = "#{@context.packagesDirectory}/#{@name}-#{@version}-#{@release}.log"
			arg = "#{exports} (set -x; #{arg}) 2>> #{logfile} >> #{logfile} "

		os.execute arg
}

