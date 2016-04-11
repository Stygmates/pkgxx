
fs = require "pkgxx.fs"

checkMakefile = =>
	fs.attributes "#{@dirname}/Makefile" or
		fs.attributes "#{@dirname}/makefile"

{
	canBuild: checkMakefile
	build: =>
		opts = @\parse table.concat {
			"PREFIX='%{prefix}'",
			"SYSCONFDIR='%{confdir}'",
			"BINDIR='%{bindir}'",
			"LIBDIR='%{libdir}'",
			"SHAREDIR='%{sharedir}'",
			"MANDIR='%{mandir}'",
			unpack (@recipe["install-options"] or {})
		}, " "

		fs.changeDirectory @dirname, ->
			if fs.attributes "Makefile" or fs.attributes "makefile"
				fs.execute @, "make #{opts}",
	canInstall: checkMakefile
	install: =>
		opts = @\parse table.concat {
			"PREFIX='%{prefix}'",
			"SYSCONFDIR='%{confdir}'",
			"BINDIR='%{bindir}'",
			"LIBDIR='%{libdir}'",
			"SHAREDIR='%{sharedir}'",
			"MANDIR='%{mandir}'",
			unpack (@recipe["install-options"] or {})
		}, " "

		fs.changeDirectory @dirname, ->
			if fs.attributes "Makefile" or fs.attributes "makefile"
				fs.execute @, "make #{opts} DESTDIR='#{@\packagingDirectory "_"}' install"
}

