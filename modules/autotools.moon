
fs = require "pkgxx.fs"

{
	configure: =>
		fs.changeDirectory @dirname, ->
			if fs.attributes "./configure"
				fs.execute @, @context.parse table.join {
					"./configure",
					"--prefix='%{prefix}'",
					"--sysconfdir='%{confdir}'"
					"--bindir='%{bindir}'"
					"--libdir='%{libdir}'"
				}, " "
}

