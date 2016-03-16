
ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

list = (a) ->
	str = ""

	for i = 1, #a
		if i != #a
			str = str .. ", " .. tostring a[i]
		else
			str = str .. tostring a[i]

	str

debarch = (arch) ->
	switch arch
		when "x86_64"
			"amd64"
		else
			arch

control = (dest) =>
	file = io.open dest, "w"

	file\write "Package: #{@name\gsub "_", "-"}\n"
	file\write "Version: #{@version}\n"
	file\write "Description: #{@description}\n"
	file\write "Maintainer: #{@maintainer}\n"
	file\write "Architecture: #{debarch @architecture}\n"
	file\write "Depends: #{list @dependencies}\n"

	-- Final, empty newline. Required.
	file\write "\n"

	file\close!

{
	target: =>
	package: =>
		unless @maintainer
			ui.warning "No 'maintainer'!"
		unless @description
			ui.warning "No 'description'!"

		target = "#{@name\gsub "_", "-"}_#{@version}-#{@release}" ..
			"#{@architecture}.deb"

		ui.detail "Building '#{target}'."

		fs.mkdir "DEBIAN"

		control @, "DEBIAN/control"

		os.execute "dpkg-deb " ..
			"-Zxz -z9 --new " ..
			"--build '#{fs.currentDirectory!}' " ..
			"'#{@context.packagesDirectory}/#{target}'"

		-- Cleaning package directory for further reuse.
		fs.remove "DEBIAN"
}

