
fs = require "pkgxx.fs"

{
	build: =>
		fs.changeDirectory @dirname, ->
			if fs.attributes "Makefile" or fs.attributes "makefile"
				fs.execute @, "make",
	install: =>
		fs.changeDirectory @dirname, ->
			if fs.attributes "Makefile" or fs.attributes "makefile"
				fs.execute @, "make DESTDIR='#{@\packagingDirectory "_"}' install"
}

