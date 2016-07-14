
ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

{
	package:
		target: => "#{@name}##{@version}-#{@release}.pkg.tar.xz"
		build: =>
			ui.detail "Building '#{@target}'."
			false ~= os.execute "tar cJf '#{@context.packagesDirectory}/#{@target}' '.'"

	installPackage: (filename) ->
		-- FIXME: check prior installation and use -u to update package
		false ~= os.execute "pkgadd '#{filename}'"
	isInstalled: (name) ->
		false ~= os.execute "pkginfo -i | grep -q '^#{name}$'"
}

