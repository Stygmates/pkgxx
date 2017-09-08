require "moonscript"
require "coveralls.coveralls"

output = ->
	Coveralls.service_name = Coveralls.Local if os.getenv 'LOCAL'
	Coveralls.service_name = Coveralls.Debug if os.getenv 'COVERALLS_DEBUG'

	Coveralls.dirname = "./"

	defout = (assert require "busted.outputHandlers.utfTerminal") {}
	suiteEnd = defout.suiteEnd
	suiteStart = defout.suiteStart

	defout.suiteStart = (desc, test_count) ->
		Coveralls\start!
		if suiteStart
			return suiteStart desc, test_count
		else
			return nil, true

	defout.suiteEnd = (statuses, options, ms) ->
		Coveralls\stop!
		Coveralls\coverDir Coveralls.dirname, Coveralls.ext if Coveralls.dirname != ""
		Coveralls\cover src for src in *Coveralls.srcs
		print Coveralls\send!
		if suiteEnd
			return suiteEnd statuses, options, ms if suiteEnd
		else
			return nil, true

	defout

return output
