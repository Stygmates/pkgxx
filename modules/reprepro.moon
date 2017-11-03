
fs = require "pkgxx.fs"
ui = require "pkgxx.ui"

{
	-- FIXME: We need to invest a lot of work in updating that configuration.
	makeRepository: =>
		if fs.attributes "conf/distributions"
			return

		@\info "Building PPA."
		fs.mkdir "conf"

		f = io.open "conf/distributions", "w"
		f\write "Codename: #{@configuration["distribution-codename"]}\n"
		f\write "Components: main\n"
		f\write "Architectures: #{@modules.dpkg._debarch context: self}\n"
		f\write "\n"
		f\close!

	addToRepository: (package, opt) =>
		@\info "Adding '#{package.target}' to PPA."

		cn = @configuration["distribution-codename"]

		-- FIXME: reprepro list #{cn} #{package.name} | grep -q "|#{@modules.dpkg._debarch @}:"
		--        We just need a reliable os.execute before that.
		if opt.force
			-- Just in case?
			os.execute "reprepro -Vb." ..
				" -A #{@modules.dpkg._debarch context: self}" ..
				" remove '#{cn}' '#{package.name}'"

		os.execute "reprepro -Vb ." ..
			" -S main" ..  -- Section. Required.
			" -P extra" .. -- Priority. Required.
			" includedeb '#{cn}' " ..
			package.target
}

