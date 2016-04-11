
fs = require "pkgxx.fs"
ui = require "pkgxx.ui"

{
	-- FIXME: We need to invest a lot of work in updating that configuration.
	makeRepository: =>
		if fs.attributes "conf/distributions"
			return

		ui.info "Building PPA."
		fs.mkdir "conf"

		f = io.open "conf/distributions", "w"
		f\write "Codename: #{@configuration["distribution-codename"]}\n"
		f\write "Components: main\n"
		f\write "Architectures: #{@modules.dpkg._debarch @}\n"
		f\write "\n"
		f\close!

	addToRepository: (package) =>
		ui.info "Adding '#{package.target}' to PPA."
		-- Just in case?
		os.execute "reprepro -Vb." ..
			" -A #{@modules.dpkg._debarch @}" ..
			" remove '#{@configuration["distribution-codename"]}' '#{package.name}'"

		os.execute "reprepro -Vb ." ..
			" -S main" ..  -- Section. Required.
			" -P extra" .. -- Priority. Required.
			" includedeb '#{@configuration["distribution-codename"]}' " ..
			package.target
}

