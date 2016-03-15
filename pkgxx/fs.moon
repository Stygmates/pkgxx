
ui = require "pkgxx.ui"
lfs = require "lfs"

{
	mkdir: (dir) ->
		-- FIXME: use lfs
		-- FIXME: rename makeDirectory or something
		os.execute "mkdir -p '#{dir}'"

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

	-- That particular function is hell. Please add debuggings stuff
	-- to it.
	changeDirectory: (newDir, f) ->
		oldDir = lfs.currentdir!

		r, e = lfs.chdir newDir
		if r
			f!
			lfs.chdir oldDir
		else
			error e

	currentDirectory: lfs.currentdir,

	attributes: lfs.attributes,
	dir: lfs.dir,

	execute: (arg) =>
		unless @context.verbose
			arg = "(#{arg}) > #{@context.packagesDirectory}/#{@name}-#{@version}-#{@release}.log"

		os.execute arg
}

