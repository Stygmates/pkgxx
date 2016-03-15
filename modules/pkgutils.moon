
ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

{
	package: =>
		target = "#{@name}##{@version}-#{@release}.tar.gz"

		ui.detail "Building '#{target}'."
		os.execute "tar czf '#{@context.packagesDirectory}/#{target}' '.'"
}

