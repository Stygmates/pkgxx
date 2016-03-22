
moonscript = require "moonscript"

ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

Recipe = require "pkgxx.recipe"

class
	new: (configuration) =>
		@configuration = configuration or {}

		unless @configuration.verbosity
			@configuration.verbosity = 4

		home = os.getenv "HOME"

		stat = io.open "/proc/self/stat", "r"
		pid = tonumber ((stat\read "*line")\gsub " .*", "")
		stat\close!

		@randomKey = math.random 0, 65535

		@sourcesDirectory  = @configuration.sourcesDirectory or "#{home}"
		@packagesDirectory = @configuration.packagesDirectory or "#{home}"
		@buildingDirectory    = "/tmp/pkgxx-#{pid}-#{@randomKey}"

		@builder = @configuration["builder"]

		@distribution = @configuration["distribution"]
		@packageManager = @configuration["package-manager"]

		@compressionMethod = "gz"

		-- An associative array of stuff to export when running
		-- external commands in order to build softwares.
		@exports = {}

		-- Setting default architecture based on the machine’s real
		-- architecture.
		p = io.popen "uname -m"
		@architecture = p\read "*line"
		p\close!

		fs.mkdir @buildingDirectory

		@\loadModules!

		@\checkConfiguration!

	loadModules: =>
		@modules = {}

		-- FIXME: That ain’t reconfigurable…
		directories = {
			"./modules",
			"/usr/share/pkgxx",
			"/usr/local/share/pkgxx"
		}

		for dir in *directories
			if fs.attributes dir
				for filename in fs.dir dir
					if (not filename\match "%.moon$") and (not filename\match "%.lua$")
						continue

					ui.debug "Loading module '#{filename}'."

					name = filename\gsub "%.moon$", ""
					name =     name\gsub "%.lua$",  ""

					file = io.open "#{dir}/#{filename}", "r"
					content = file\read "*all"
					file\close!

					local code, e
					if filename\match "%.moon$"
						code, e = moonscript.loadstring content
					else
						code, e = loadstring content

					if code
						module = code!
						@modules[name] = module

						if module.name and not @modules[module.name]
							@modules[module.name] = module
					else
						io.stderr\write "module '#{name}' not loaded: #{e}\n"

	checkConfiguration: =>
		if not @modules[@packageManager]
			ui.warning "No module for the following package manager: " ..
				"'#{@packageManager}'."

			ui.warning "Package manager set to 'pkgutils'."
			@packageManager = "pkgutils"

	openRecipe: (filename) =>
		Recipe (filename or "package.toml"), @

	close: =>
		fs.remove @buildingDirectory

	__tostring: =>
		"<pkgxx:xContext: #{@pid}-#{@randomKey}>"

