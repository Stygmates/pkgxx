
ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

getSize = ->
	-- -sb would have been preferable on Arch, but that ain’t
	-- supported on all distributions using pacman derivatives!
	p = io.popen "du -sk ."
	size = (p\read "*line")\gsub " .*", ""
	size = size\gsub "%s.*", ""
	size = (tonumber size) * 1024
	p\close!

	size

pkginfo = (size, f) =>
	f\write "# Generated by pkg++ (moonscript edition)\n"
	f\write "pkgname = #{@name}\n"

	if @context.packageManager == "apk"
		f\write "pkgver = #{@version}-r#{@release - 1}\n"
	else
		f\write "pkgver = #{@version}-#{@release}\n"

	if @summary
		f\write "pkgdesc = #{@summary}\n"

	if @url
		f\write "url = #{@url}\n"

	p = io.popen "LC_ALL=C date -u\n"
	date = p\read "*line\n"
	p\close!

	f\write "builddate = #{date}\n"

	f\write "buildtype = host\n"

	if @context.builder
		f\write "packager = #{@context.builder}\n"
	if @origin.maintainer or @origin.packager
		f\write "maintainer = #{@origin.maintainer or @origin.packager}\n"

	-- FIXME: check the license format — in distro modules?
	if @license
		f\write "license = #{@license}\n"

	f\write "size = #{size}\n"
	f\write "arch = #{@context.architecture}\n"
	f\write "origin = #{@origin.name}\n"

	for group in *@groups
		f\write "group = #{group}\n"

	for atom in *@dependencies
		f\write "depend = #{atom.name}\n"

	for atom in *@conflicts
		f\write "conflict = #{atom.name}\n"

	for atom in *@provides
		f\write "provides = #{atom.name}\n"

genPkginfo = (size) =>
	f = io.open ".PKGINFO", "w"
	pkginfo @, size, f
	f\close!

{
	check: =>
		if @context.packageManager == "apk"
			unless os.execute "abuild-sign --installed"
				ui.error "You need to generate a key with " ..
					"'abuild-keygen -a'."
				ui.error "No APK package can be built without " ..
					"being signed."

				return nil, "no abuild key"

	_genPkginfo: genPkginfo

	package:
		target: => "#{@name}-#{@version}-#{@release}-" ..
				"#{@context.architecture}.pkg.tar.xz"
		build: =>
			unless @context.builder
				ui.warning "No 'builder' was defined in your configuration!"

			size = getSize!

			genPkginfo @, size

			ui.detail "Building '#{@target}'."

			os.execute "tar cJf " ..
				"'#{@context.packagesDirectory}/#{@target}' " ..
				".PKGINFO *"
		install: (filename) =>
			fs.execute context: self, "pacman -U '#{filename}'"
	isInstalled: (name) =>
		fs.execute context: self, "pacman -Q '#{name}'"
	installDependency: (name) =>
		fs.execute context: self, "pacman -S --noconfirm '#{name}'"
}

