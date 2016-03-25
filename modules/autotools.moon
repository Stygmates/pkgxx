
fs = require "pkgxx.fs"

{
	configure: =>
		fs.changeDirectory @dirname, ->
			if fs.attributes "./configure"
				fs.execute @, @\parse table.concat {
					"./configure",
					"--prefix='%{prefix}'",
					"--sysconfdir='%{confdir}'"
					"--bindir='%{bindir}'"
					"--libdir='%{libdir}'"
					unpack (@recipe["configure-options"] or {})
				}, " "
}

