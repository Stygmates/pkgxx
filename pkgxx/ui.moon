
-- FIXME: Disable if needed.
colors = {
	red:    "\027[01;31m",
	green:  "\027[01;32m",
	yellow: "\027[01;33m",
	blue:   "\027[01;34m",
	cyan:   "\027[00;36m",
	white:  "\027[00;37m",
	brightwhite:  "\027[01;37m",
	clear:  "\027[00m",
}

-- FIXME: Merge in Context.

verbosity = 2

{
	-- what the hell. How did it come to this?
	setVerbosity: (v) -> verbosity = v,
	getVerbosity: -> verbosity,

	debug: (...) ->
		if verbosity >= 5
			io.stdout\write colors.cyan, ":: "
			io.stdout\write ...
			io.stdout\write colors.clear, "\n",

	detail: (...) ->
		if verbosity >= 4
			io.stdout\write colors.blue, "-- ", colors.white
			io.stdout\write ...
			io.stdout\write colors.clear, "\n",

	info: (...) ->
		if verbosity >= 3
			io.stdout\write colors.green, "-> ", colors.brightwhite
			io.stdout\write ...
			io.stdout\write colors.clear, "\n",

	warning: (...) ->
		if verbosity >= 2
			io.stderr\write colors.yellow, "?? "
			io.stderr\write ...
			io.stderr\write colors.clear, "\n",

	error: (...) ->
		if verbosity >= 1
			io.stderr\write colors.red, "!! "
			io.stderr\write ...
			io.stderr\write colors.clear, "\n",
}

