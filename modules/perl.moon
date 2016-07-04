
fs = require "pkgxx.fs"

unpack = unpack or table.unpack

{
	canConfigure: =>
		(fs.attributes "#{@dirname}/Makefile.PL") ~= nil
	configure: =>
		fs.changeDirectory @dirname, ->
			if fs.attributes "./Makefile.PL"
				fs.execute @, @\parse table.concat {
					"perl ./Makefile.PL",
					"prefix='%{prefix}'"
					unpack (@recipe["configure-options"] or {})
				}, " "
}

