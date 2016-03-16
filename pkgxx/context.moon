
moonscript = require "moonscript"

ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

Recipe = require "pkgxx.recipe"

class
	new: (configuration) =>
		@configuration = configuration or {}

		home = os.getenv "HOME"

		stat = io.open "/proc/self/stat", "r"
		pid = tonumber ((stat\read "*line")\gsub " .*", "")
		stat\close!

		@randomKey = math.random 0, 65535

		@sourcesDirectory  = "#{home}"
		@packagesDirectory = "#{home}"
		@buildingDirectory    = "/tmp/pkgxx-#{pid}-#{@randomKey}"

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
					if not filename\match "%.moon$" or filename\match "%.lua$"
						continue

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
						@modules[name] = code!
					else
						io.stderr\write "module '#{name}' not loaded: #{e}\n"

	checkConfiguration: =>
		if not @modules[@configuration['package-manager']]
			ui.warning "No module for the following package manager: " ..
				"'#{@configuration['package-manager']}'."

			ui.warning "Package manager set to 'pkgutils'."
			@configuration['package-manager'] = "pkgutils"

	openRecipe: (filename) =>
		Recipe (filename or "package.toml"), @

	close: =>
		fs.remove @buildingDirectory

	__tostring: =>
		"<pkgxx:xContext: #{@pid}-#{@randomKey}>"

