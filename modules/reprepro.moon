
fs = require "pkgxx.fs"
ui = require "pkgxx.ui"

{
	-- FIXME: We need to invest a lot of work in updating that configuration.
	makeRepository: =>
		os.execute "pwd"

		unless fs.attributes "conf"
			ui.info "Building PPA."
			fs.mkdir "conf"

			f = io.open "conf/distributions", "w"
			f\write "Codename: jessie\n"
			f\write "Components: main\n"
			f\write "Architectures: #{@modules.dpkg._debarch @architecture}\n"
			f\write "\n"
			f\close

	addToRepository: (package) =>
		ui.info "Adding '#{package.target}' to PPA."
		-- Just in case?
		os.execute "reprepro -Vb." ..
			" -A #{@modules.dpkg._debarch @architecture}" ..
			" remove 'jessie' '#{package.name}'"

		os.execute "reprepro -Vb ." ..
			" -S main" ..  -- Section. Required.
			" -P extra" .. -- Priority. Required.
			" includedeb 'jessie' " ..
			package.target
}

