
ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

{
	canConfigure: =>
		fs.attributes "#{@dirname}/project.zsh"
	configure: =>
		fs.changeDirectory @dirname, ->
			if fs.attributes "./project.zsh"
				if fs.attributes "Makefile"
					ui.debug "Configuration not done because Makefile already generated."
					true
				else
					fs.execute @, "build.zsh -c -g"
}

