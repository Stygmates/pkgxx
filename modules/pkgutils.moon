
ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

{
	target: => "#{@name}##{@version}-#{@release}.pkg.tar.xz"
	package: =>
		ui.detail "Building '#{@target}'."
		os.execute "tar cJf '#{@context.packagesDirectory}/#{@target}' '.'"
}

