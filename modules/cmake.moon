
fs = require "pkgxx.fs"

unpack = unpack or table.unpack

{
	canConfigure: =>
		fs.attributes "#{@dirname}/CMakeLists.txt"
	configure: =>
		fs.changeDirectory @dirname, ->
			if fs.attributes "CMakeLists.txt"
				fs.execute @, @\parse table.concat {
					"cmake .",
					"-DCMAKE_INSTALL_PREFIX=%{prefix}",
					unpack (@recipe["cmake-options"] or {})
				}, " "
}

