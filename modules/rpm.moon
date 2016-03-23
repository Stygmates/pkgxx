
ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

writeSpec = (f) =>
	dir = @name
	if @ == @origin
		dir = "_"

	f\write "Summary:   #{@summary}\n"
	f\write "Name:      #{@name}\n"
	f\write "Version:   #{@version}\n"
	f\write "Release:   #{@release}%{?dist}\n"
	f\write "License:   #{@license}\n"

	f\write "BuildRoot: /usr\n"

	-- Documentation says not to use this on Fedora?	
	--f\write "Packager:  #{@packager}\n"

	-- Deprecated since Fedora 17?
	if #@groups > 0
		f\write "Group: "
		for group in *@groups
			f\write " ", group
		f\write "\n"

	if #@dependencies > 0
		f\write "Requires: "
		for depend in *@dependencies
			f\write " ", depend
		f\write "\n"

	f\write "\n"
	f\write "%description\n"
	f\write "#{@description}\n"
	f\write "\n"
	f\write "%files\n"
	f\write "/\n"
	-- FIXME: We should assign package-owned directories, with %dir dirname.

dist = ->
	p = io.popen "rpm --eval '%dist'"
	rpm_dist = p\read "*line"
	p\close!

	return rpm_dist or ""

{
	target: => "#{@name}-#{@version}-#{@release}-#{@architecture}#{dist!}.rpm"
	package: =>
		dir = @name
		if @ == @origin
			dir = "_"

		ui.detail "Building '#{@target}'."

		fs.changeDirectory "..", ->
			dir = @name
			if @ == @origin
				dir = "_"

			f = io.open "#{@name}.spec", "w"
			writeSpec @, f
			f\close!

			p = io.popen "pwd"
			pwd = p\read "*line"
			p\close!

			os.execute "rpmbuild --quiet" ..
				" --define '_topdir #{pwd}/../RPM'" ..
				" --define '_rpmdir #{pwd}/../'" ..
				" --buildroot='#{pwd}/#{dir}'" ..
				" -bb #{@name}.spec"

			-- FIXME: We need the list of RPM architectures.
			arch = @architecture

			os.execute "mv" ..
				" '#{pwd}/../#{arch}/#{@name}-#{@version}-#{@release}#{dist!}.#{arch}.rpm'" ..
				" '#{@context.packagesDirectory}/#{@target}'"
}

