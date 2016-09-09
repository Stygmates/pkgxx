
ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

{
	watch: =>
		if not @version and #@sources >= 1 and @sources[1].url\match "://github.com/[a-zA-Z0-9]*/[a-zA-Z0-9]*"

			{
				url: @sources[1].url
				selector: ".numbers-summary .commits .num.text-emphasized"
				subs: {{",", ""}}
			}
}

