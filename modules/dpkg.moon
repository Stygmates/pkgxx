
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

debarch = (arch) ->
	switch arch
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
	file\write "Version: #{@version}\n"
	file\write "Description: #{@summary}\n"

	if @description
		file\write (paragraph @description), "\n"

	file\write "Maintainer: #{@maintainer}\n"
	file\write "Architecture: #{debarch @architecture}\n"
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

{
	target: => "#{@name\gsub "_", "-"}_#{@version}-#{@release}" ..
			"-#{@architecture}.deb"
	package: =>
		unless @maintainer
			ui.warning "No 'maintainer'!"
		unless @description
			ui.warning "No 'description'!"

		ui.detail "Building '#{@target}'."

		fs.mkdir "DEBIAN"

		control @, "DEBIAN/control"

		if @license and @copyright
			copyright @, "DEBIAN/copyright"
		else
			ui.warning "No debian/copyright file will be generated "
			ui.warning "due to no 'license' or 'copyright' field."

		os.execute "dpkg-deb " ..
			"-Zxz -z9 --new " ..
			"--build '#{fs.currentDirectory!}' " ..
			"'#{@context.packagesDirectory}/#{@target}'"

		-- Cleaning package directory for further reuse.
		fs.remove "DEBIAN"
}

