
-- FIXME: Disable if needed.
colors = {
	red:    "\027[01;31m",
	green:  "\027[01;32m",
	yellow: "\027[01;33m",
	blue:   "\027[01;34m",
	cyan:   "\027[00;36m",
	white:  "\027[00;37m",
	brightmagenta: "\027[01;35m",
	brightwhite:  "\027[01;37m",
	clear:  "\027[00m",
}

-- FIXME: Merge in Context.
verbosity = 2

powerline = os.getenv "POWERLINE"

{
	-- what the hell. How did it come to this?
	setVerbosity: (v) -> verbosity = v,
	getVerbosity: -> verbosity,

	debug: (...) ->
		if verbosity >= 5
			unless powerline
				io.stdout\write colors.cyan, ":: "
				io.stdout\write ...
				io.stdout\write colors.clear, "\n"
			else
				io.stdout\write colors.brightwhite, "\027[46m debug "
				io.stdout\write colors.clear, "\027[36m "
				io.stdout\write colors.clear, colors.white
				io.stdout\write ...
				io.stdout\write colors.clear, "\n"

	detail: (...) ->
		if verbosity >= 4
			unless powerline
				io.stdout\write colors.blue, "-- ", colors.white
				io.stdout\write ...
				io.stdout\write colors.clear, "\n"
			else
				io.stdout\write colors.brightwhite, "\027[44m info ",
					colors.clear, "\027[34m ",
					colors.clear, colors.white
				io.stdout\write ...
				io.stdout\write colors.clear, "\n"

	info: (...) ->
		if verbosity >= 3
			unless powerline
				io.stdout\write colors.green, "-> ", colors.brightwhite
				io.stdout\write ...
				io.stdout\write colors.clear, "\n"
			else
				io.stdout\write colors.brightwhite, "\027[42m info ",
					colors.clear, "\027[32m ",
					colors.clear, colors.brightwhite
				io.stdout\write ...
				io.stdout\write colors.clear, "\n"

	section: (...) ->
		if verbosity >= 2
			unless powerline
				io.stdout\write colors.brightmagenta, "|>  ", colors.brightwhite
				io.stdout\write ...
				io.stdout\write colors.clear, "\n"
			else
				io.stdout\write colors.brightwhite, "\027[45m package ",
					colors.clear, "\027[35m ",
					colors.clear, colors.brightwhite
				io.stdout\write ...
				io.stdout\write colors.clear, "\n"

	warning: (...) ->
		if verbosity >= 2
			unless powerline
				io.stderr\write colors.yellow, "?? "
				io.stderr\write ...
				io.stderr\write colors.clear, "\n"
			else
				io.stderr\write colors.brightwhite, "\027[43m warn ",
					colors.clear, "\027[33m ",
					colors.clear, colors.yellow
				io.stderr\write ...
				io.stderr\write colors.clear, "\n"

	error: (...) ->
		if verbosity >= 1
			unless powerline
				io.stderr\write colors.red, "!! "
				io.stderr\write ...
				io.stderr\write colors.clear, "\n"
			else
				io.stderr\write colors.brightwhite, "\027[41m error ",
					colors.clear, "\027[31m ",
					colors.clear, colors.red
				io.stderr\write ...
				io.stderr\write colors.clear, "\n"
}

