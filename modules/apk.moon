
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

makeRepository = =>
	ui.info "Building 'apk' repository."

	index = "#{@packagesDirectory}/#{@architecture}/APKINDEX.tar.gz"

	local oldIndex
	if lfs.attributes index
		oldIndex = " --index #{index}"
	else
		oldIndex = ""

	output = " --output '#{index}.unsigned'"

	r, e = os.execute "apk index --quiet #{oldIndex} #{output}" ..
		" --description 'test test'" ..
		" --rewrite-arch '#{@architecture}'" ..
		" #{@packagesDirectory}/*.apk"

	unless r
		return nil, e

	r, e = os.execute "abuild-sign -q '#{index}.unsigned'"

	unless r
		return nil, e

	os.execute "mv '#{index}.unsigned' '#{index}'"

{
	target: =>
		-- We need to store the packages in a sub-directory to be able
		-- to build valid apk repositories.
		"#{@context.architecture}/" ..
			"#{@name}-#{@version}-r#{@release - 1}.apk"
	check: =>
		unless os.execute "abuild-sign --installed"
			ui.error "You need to generate a key with " ..
				"'abuild-keygen -a'."
			ui.error "No APK package can be built without " ..
				"being signed."

			return nil, "no abuild key"

	package: =>
		unless @context.builder
			ui.warning "No 'builder' was defined in your configuration!"

		size = getSize!

		@context.modules.pacman._genPkginfo @, size

		ui.detail "Building '#{@target}'."
		fs.mkdir @context.packagesDirectory .. "/" ..
			@context.architecture
		os.execute [[
			tar --xattrs -c * | abuild-tar --hash | \
				gzip -9 > ../data.tar.gz

			mv .PKGINFO ../

			# append the hash for data.tar.gz
			local sha256=$(sha256sum ../data.tar.gz | cut -f1 -d' ')
			echo "datahash = $sha256" >> ../.PKGINFO

			# control.tar.gz
			cd ..
			tar -c .PKGINFO | abuild-tar --cut \
				| gzip -9 > control.tar.gz
			abuild-sign -q control.tar.gz || exit 1

			# create the final apk
			cat control.tar.gz data.tar.gz > ]] ..
				"'#{@context.packagesDirectory}/#{@target}'"

	addToRepository: (target, opt) =>
		makeRepository target, opt
	makeRepository: => (target, opt) =>
		makeRepository target, opt

	installDependency: (name) ->
		os.execute "apk add '#{name}'"

	installPackage: (name) ->
		os.execute "apk add --allow-untrusted '#{name}'"

	isInstalled: (name) ->
		p = io.popen "apk add --interactive '#{name}'"
		p\write "n\n"
		p\read "*all"
		p\close!
}


