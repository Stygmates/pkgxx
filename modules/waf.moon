
fs = require "pkgxx.fs"

{
	configure: =>
		fs.changeDirectory @dirname, ->
			if fs.attributes "./waf"
				fs.execute @, @\parse table.concat {
					"./waf configure",
					"--prefix='%{prefix}'",
					unpack (@recipe["configure-options"] or {})
				}, " "
	build: =>
		fs.changeDirectory @dirname, ->
			if fs.attributes "./waf"
				fs.execute @, "./waf",
	install: =>
		fs.changeDirectory @dirname, ->
			if fs.attributes "./waf"
				fs.execute @, "./waf install " ..
					"--destdir='#{@\packagingDirectory "_"}'"
}


