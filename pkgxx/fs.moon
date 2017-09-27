
ui = require "pkgxx.ui"
lfs = require "lfs"
process = require "process"

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

	---
	-- FIXME: Move to Context.
	execute: (arg) =>
		exports = ""

		for key, value in pairs @context.exports
			exports = exports .. "export #{key}='#{value}'\n"

		logfile = "#{@context.packagesDirectory}/#{@name}-#{@version}-#{@release}.log"

		verbosity = ui.getVerbosity!

		child = process.exec "sh", {"-c", "set -e -x\n#{exports}\n#{arg}"}

		while true
			stdout, stdoutError, stdoutAgain = child\stdout!
			stderr, stderrError, stderrAgain = child\stderr!

			if stderr
				@context\log stderr

				-- FIXME: Who ever though integers were good enough for this?
				if verbosity >= 5
					io.stderr\write stderr

			if stderrError
				@context\log stderrError

				if verbosity >= 3
					io.stderr\write stderrError

			if stdout
				@context\log stdout

				if verbosity >= 6
					io.stdout\write stdout

			if stdoutError
				@context\log stdoutError

				if verbosity >= 3
					io.stderr\write stdoutError

			if not stdout and not stdoutAgain and not stderr and not stderrAgain
				break

		status = process.waitpid child\pid!

		if status.exit != 0
			io.stderr\write "Last command returned #{status.exit}"
			return false, status.exit

		true
}

