
ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

{
	package:
		target: => "#{@name}##{@version}-#{@release}.pkg.tar.xz"
		build: =>
			ui.detail "Building '#{@target}'."
			false ~= os.execute "tar cJf '#{@context.packagesDirectory}/#{@target}' '.'"

		install: (filename) ->
			-- FIXME: check prior installation and use -u to update package
			false ~= os.execute "pkgadd '#{filename}'"
	isInstalled: (name) =>
		fs.execute context: self, "pkginfo -i | grep -q '^#{name}$'"
}

