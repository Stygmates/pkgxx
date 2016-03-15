
fs = require "pkgxx.fs"

{
	configure: =>
		fs.changeDirectory @dirname, ->
			if fs.attributes "./configure"
				fs.execute @, "./configure --prefix='/usr'"
}

