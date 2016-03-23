
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

{
	target: => "#{@name}-#{@version}-r#{@release - 1}.apk"
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
}

