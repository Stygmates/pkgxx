
ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

has = (e, a) ->
	for k, v in pairs a
		if v == e
			return true

writeSpec = (f) =>
	f\write "Summary:   #{@summary}\n"
	f\write "Name:      #{@name}\n"
	f\write "Version:   #{@version}\n"
	f\write "Release:   #{@release}%{?dist}\n"
	f\write "License:   #{@license}\n"

	if @hasOption "no-arch"
		f\write "BuildArch: noarch\n"

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
		for atom in *@dependencies
			f\write " ", atom.name
		f\write "\n"

	f\write "\n"
	f\write "%description\n"
	f\write "#{@description}\n"
	f\write "\n"

	f\write "%files\n"
	fs.changeDirectory (@origin\packagingDirectory @name), ->
		p = io.popen "find ."
		for line in p\lines!
			file = line\sub 2, #line

			-- Directories ignored until we can safely determine which are
			-- part of the system and which are not.
			unless (lfs.symlinkattributes line).mode == "directory"
				f\write file, "\n"

		p\close!

-- FIXME: We need the list of RPM architectures.
rpmArch = =>
	arch = @architecture
	if @hasOption "no-arch"
		arch = "noarch"

	arch

dist = ->
	p = io.popen "rpm --eval '%dist'"
	rpm_dist = p\read "*line"
	p\close!

	return rpm_dist or ""

{
	package:
		target: =>
			"#{@name}-#{@version}-#{@release}#{dist!}.#{rpmArch @}.rpm"
		build: =>
			dir = @name

			ui.detail "Building '#{@target}'."

			fs.changeDirectory "..", ->
				dir = @name

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

				arch = rpmArch @

				os.execute "mv" ..
					" '#{pwd}/../#{arch}/#{@target}'" ..
					" '#{@context.packagesDirectory}/#{@target}'"
		install: (filename) ->
			false ~= os.execute "rpm -i '#{filename}'"

	isInstalled: (name) ->
		-- Being silent.
		p = io.popen "rpm -V --noscripts --nodeps --nofiles #{name}"
		p\read "*all"
		p\close!
}

