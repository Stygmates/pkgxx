
fs = require "pkgxx.fs"

unpack = unpack or table.unpack

checkWaf = => fs.attributes "#{@dirname}/waf"

{
	canConfigure: checkWaf
	canBuild: checkWaf
	canInstall: checkWaf

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


