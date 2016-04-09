
fs = require "pkgxx.fs"

{
	build: =>
		opts = @\parse table.concat {
			"PREFIX='%{prefix}'",
			"SYSCONFDIR='%{confdir}'",
			"BINDIR='%{bindir}'",
			"LIBDIR='%{libdir}'",
			"MANDIR='%{mandir}'",
			unpack (@recipe["install-options"] or {})
		}, " "

		fs.changeDirectory @dirname, ->
			if fs.attributes "Makefile" or fs.attributes "makefile"
				fs.execute @, "make #{opts}",
	install: =>
		opts = @\parse table.concat {
			"PREFIX='%{prefix}'",
			"SYSCONFDIR='%{confdir}'",
			"BINDIR='%{bindir}'",
			"LIBDIR='%{libdir}'",
			"MANDIR='%{mandir}'",
			unpack (@recipe["install-options"] or {})
		}, " "

		fs.changeDirectory @dirname, ->
			if fs.attributes "Makefile" or fs.attributes "makefile"
				fs.execute @, "make #{opts} DESTDIR='#{@\packagingDirectory "_"}' install"
}

