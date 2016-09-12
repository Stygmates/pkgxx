
ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

list = (a) ->
	str = ""

	for i = 1, #a
		if i != #a
			str = str .. tostring a[i] .. ", "
		else
			str = str .. tostring a[i]

	str

debarch = =>
	if @hasOption and @hasOption "no-arch"
		"all"
	else
		switch @architecture
			when "x86_64"
				"amd64"
			else
				arch

paragraph = (text) ->
	text = text\gsub "\n$",  ""
	text = text\gsub "\n\n", "\n.\n"
	text = text\gsub "\n",   "\n  "
	text = text\gsub "\t",   " "

	return " " .. text

control = (dest) =>
	file = io.open dest, "w"

	file\write "Package: #{@name\gsub "_", "-"}\n"
	file\write "Version: #{@version}-#{@release}\n"
	file\write "Description: #{@summary}\n"

	if @description
		file\write (paragraph @description), "\n"

	file\write "Maintainer: #{@maintainer}\n"

	file\write "Architecture: #{debarch @}\n"

	if #@dependencies > 0
		file\write "Depends: #{list @dependencies}\n"

	-- Final, empty newline. Required.
	file\write "\n"

	file\close!

debian_copyright = "http://www.debian.org/doc/packaging-manuals/copyright-format/1.0/"

copyright = (dest) =>
	file = io.open dest, "w"

	file\write "Format: #{debian_copyright}\n"
	file\write "\n"
	file\write "Files: *\n"
	file\write "Copyright: #{@copyright}\n"
	file\write "License: #{@license}\n"
	file\write "\n"

	file\close!

buildDeb = =>
	unless @maintainer
		ui.warning "No 'maintainer'!"
	unless @description or @summary
		ui.warning "No 'description' or 'summary'!"

	ui.detail "Building '#{@target}'."

	fs.mkdir "DEBIAN"

	control @, "DEBIAN/control"

	if @license and @copyright
		copyright @, "DEBIAN/copyright"
	else
		ui.detail "No debian/copyright file will be generated "
		ui.detail "due to no 'license' or 'copyright' field."

	os.execute "dpkg-deb " ..
		"-Zxz -z9 --deb-format=2.0 " ..
		"--build '#{fs.currentDirectory!}' " ..
		"'#{@context.packagesDirectory}/#{@target}'"

	-- Cleaning package directory for further reuse.
	fs.remove "DEBIAN"

{
	_debarch: debarch
	package:
		target: =>
			arch = if @hasOption "no-arch"
					"all"
				else
					@architecture

			"#{@name\gsub "_", "-"}_#{@version}-#{@release}" ..
				"_#{arch}.deb"
		build: buildDeb
		install: (filename) ->
			false ~= os.execute "dpkg -i '#{filename}'"

	isInstalled: (name) ->
		false ~= os.execute "dpkg -l | cut -d ' ' -f 3 | grep -q '^#{name}$'"
}

