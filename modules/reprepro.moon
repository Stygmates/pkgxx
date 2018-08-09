
fs = require "pkgxx.fs"
ui = require "pkgxx.ui"

try = (object, callback) -> callback(object) if object

grep = (pattern, filename) ->
	content = try (io.open filename, "r"), => with @\read "*all"
		@\close!

	content\match pattern

add_codename_entry = (codename, architecture, filename) ->
	file = io.open "conf/distributions", "a"
	file\write "Codename: #{codename}\n"
	file\write "Components: main\n"
	file\write "Architectures: #{architecture}\n"
	file\write "\n"
	file\close!

{
	-- FIXME: We need to invest a lot of work in updating that configuration.
	makeRepository: =>
		codename = @configuration["distribution-codename"]
		architecture = @modules.dpkg._debarch context: self

		if fs.attributes "conf/distributions"
			unless grep codename, "conf/distributions"
				@\info "Adding codename to PPA configuration."
				add_codename_entry codename, architecture, "conf/distributions"

			return

		@\info "Building PPA."
		fs.mkdir "conf"
		add_codename_entry codename, architecture, "conf/distributions"

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

