
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

	---
	-- FIXME: Move to Context.
	execute: (arg) =>
		exports = ""

		for key, value in pairs @context.environment
			exports = exports .. "export #{key}='#{value}'\n"

		verbosity = ui.getVerbosity!

		arg = "set -e -x\n#{exports}\n#{arg}"

		arg = "sh -c \"#{arg\gsub("\\$", "\\$")\gsub("\\", "\\\\")\gsub("\"", "\\\"")}\""

		@context.logFile\flush!
		if verbosity >= 5
			-- omg
			arg = "returnFile=\"`mktemp`\";" ..
				"{ #{arg}; echo \"$?\n\" > $returnFile; } 2>&1 |" ..
					"tee -a #{@context.logFilePath};" ..
				"returnValue=\"$(cat $returnFile)\";" ..
				"rm -f \"$returnFile\";" ..
				"exit $returnValue"
		else
			arg = "#{arg} >> #{@context.logFilePath} 2>&1"

		success, _, status = os.execute arg

		if type(success) == "number"
			status = success

			if status >= 256
				status = status / 256

		if status != 0
			io.stderr\write "Last command returned #{status}\n"
			false, status
		else
			true, 0
}

