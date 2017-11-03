
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

	debug: (file, ...) ->
		unless powerline
			file\write colors.cyan, ":: "
			file\write ...
			file\write colors.clear, "\n"
		else
			file\write colors.brightwhite, "\027[46m debug "
			file\write colors.clear, "\027[36m "
			file\write colors.clear, colors.white
			file\write ...
			file\write colors.clear, "\n"

	detail: (file, ...) ->
		unless powerline
			file\write colors.blue, "-- ", colors.white
			file\write ...
			file\write colors.clear, "\n"
		else
			file\write colors.brightwhite, "\027[44m info ",
				colors.clear, "\027[34m ",
				colors.clear, colors.white
			file\write ...
			file\write colors.clear, "\n"

	info: (file, ...) ->
		unless powerline
			file\write colors.green, "-> ", colors.brightwhite
			file\write ...
			file\write colors.clear, "\n"
		else
			file\write colors.brightwhite, "\027[42m info ",
				colors.clear, "\027[32m ",
				colors.clear, colors.brightwhite
			file\write ...
			file\write colors.clear, "\n"

	section: (file, ...) ->
		unless powerline
			file\write colors.brightmagenta, "|>  ", colors.brightwhite
			file\write ...
			file\write colors.clear, "\n"
		else
			file\write colors.brightwhite, "\027[45m package ",
				colors.clear, "\027[35m ",
				colors.clear, colors.brightwhite
			file\write ...
			file\write colors.clear, "\n"

	warning: (file, ...) ->
		unless powerline
			file\write colors.yellow, "?? "
			file\write ...
			file\write colors.clear, "\n"
		else
			file\write colors.brightwhite, "\027[43m warn ",
				colors.clear, "\027[33m ",
				colors.clear, colors.yellow
			file\write ...
			file\write colors.clear, "\n"

	error: (file, ...) ->
		unless powerline
			file\write colors.red, "!! "
			file\write ...
			file\write colors.clear, "\n"
		else
			file\write colors.brightwhite, "\027[41m error ",
				colors.clear, "\027[31m ",
				colors.clear, colors.red
			file\write ...
			file\write colors.clear, "\n"
}

