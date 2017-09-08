require "moonscript"
require "coveralls.coveralls"

output = ->
	busted = require "busted"

	Coveralls.service_name = Coveralls.Local if os.getenv 'LOCAL'
	Coveralls.service_name = Coveralls.Debug if os.getenv 'COVERALLS_DEBUG'

	Coveralls.service = Coveralls.Debug
	Coveralls.dirname = "./"

	defout = (assert require "busted.outputHandlers.utfTerminal") {}
	suiteEnd = defout.suiteEnd
	suiteStart = defout.suiteStart

	defout.suiteStart = (suite, count, total) ->
		print Coveralls\start!
		if suiteStart
			return suiteStart suite, count, total
		else
			return nil, true

	defout.suiteEnd = (suite, count, total) ->
		Coveralls\stop!
		print Coveralls\coverDir Coveralls.dirname, Coveralls.ext if Coveralls.dirname != ""
		print Coveralls\cover src for src in *Coveralls.srcs
		print Coveralls\send!
		if suiteEnd
			return suiteEnd suite, count, total
		else
			return nil, true

	busted.subscribe { 'suite', 'start' }, defout.suiteStart
	busted.subscribe { 'suite', 'end' }, defout.suiteEnd

	defout

return output
