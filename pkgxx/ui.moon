
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

{
	debug: (...) ->
		io.stdout\write colors.cyan, ":: "
		io.stdout\write ...
		io.stdout\write colors.clear, "\n",

	detail: (...) ->
		io.stdout\write colors.blue, "-- ", colors.white
		io.stdout\write ...
		io.stdout\write colors.clear, "\n",

	info: (...) ->
		io.stdout\write colors.green, "-> ", colors.brightwhite
		io.stdout\write ...
		io.stdout\write colors.clear, "\n",

	warning: (...) ->
		io.stderr\write colors.yellow, "?? "
		io.stderr\write ...
		io.stderr\write colors.clear, "\n",

	error: (...) ->
		io.stderr\write colors.red, "!! "
		io.stderr\write ...
		io.stderr\write colors.clear, "\n",
}

