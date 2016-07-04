
fs = require "pkgxx.fs"

unpack = unpack or table.unpack

{
	canConfigure: =>
		fs.attributes "#{@dirname}/configure"
	configure: =>
		fs.changeDirectory @dirname, ->
			if fs.attributes "./configure"
				fs.execute @, @\parse table.concat {
					"./configure",
					"--prefix='%{prefix}'",
					"--sysconfdir='%{confdir}'"
					"--bindir='%{bindir}'"
					"--libdir='%{libdir}'"
					"--mandir='%{mandir}'"
					unpack (@recipe["configure-options"] or {})
				}, " "
}

