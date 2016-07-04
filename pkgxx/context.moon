
moonscript = require "moonscript"
toml = require "toml"

ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

Recipe = require "pkgxx.recipe"
Module = require "pkgxx.module"

class
	new: () =>
		@configuration = {
			verbosity: 4
		}

		home = os.getenv "HOME"

		pid = -666 -- Default value if /proc is unavailable.
		stat = io.open "/proc/self/stat", "r"
		if stat
			pid = tonumber ((stat\read "*line")\gsub " .*", "")
			stat\close!

		@randomKey = math.random 0, 65535

		@sourcesDirectory  = "#{home}"
		@packagesDirectory = "#{home}"
		@buildingDirectory = "/tmp/pkgxx-#{pid}-#{@randomKey}"

		@collections = {}

		@compressionMethod = "gz"

		-- Array of strings that contain the pathnames of the repositories
		-- in which pkg++ could look for dependencies.
		@repositories = {}

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

	importConfiguration: (filename) =>
		f = io.open filename

		unless f
			return nil, "file couldn’t be opened"

		content = f\read "*all"
		f\close!

		configuration = toml.parse content

		@sourcesDirectory  = configuration["sources-directory"] or @sourcesDirectory
		@packagesDirectory = configuration["packages-directory"] or @packagesDirectory

		@builder = configuration["builder"]

		@distribution = configuration["distribution"]
		@packageManager = configuration["package-manager"]
		@repositoryManager = configuration["repository-manager"]
		@dependenciesManager = configuration["dependencies-manager"]

		for variable in *{
			"CFLAGS", "CPPFLAGS", "CXXFLAGS", "FFLAGS", "LDFLAGS",
			"MAKEFLAGS"
		}
			if configuration[variable]
				context.exports[variable] = configuration[variable]

		@prefixes = {}
		for prefix in *@prefixes
			if configuration[prefix]
				@prefixes[prefix] = configuration[prefix]

		@configuration = configuration
		unless @configuration.verbosity
			@configuration.verbosity = 4

		if configuration.repositories
			for s in *configuration.repositories
				@repositories[#@repositories+1] = s

		if configuration.collections
			for name, col in pairs configuration.collections
				ui.debug "Registering collection '#{name}'."
				@collections[name] = col

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
						module = Module code!
						@modules[name] = module
						module.name = module.name or name

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

		if @repositoryManager and not @modules[@repositoryManager]
			if @repositoryManager == "none"
				@repositoryManager = nil
			else
				ui.warning "No module for the following repository manager: " ..
					"'#{@repositoryManager}'."

				if @modules[@packageManager].makeRepository
					ui.warning "Repository manager set to " ..
						"'#{@packageManager}'."
					@repositoryManager = @packageManager
				else
					ui.warning "No repository will be generated."
					@repositoryManager = nil

	openRecipe: (filename) =>
		Recipe (filename or "package.toml"), @

	updateRepository: (opt) =>
		unless @repositoryManager
			return

		module = @modules[@repositoryManager or @packageManager].makeRepository
		if module
			fs.changeDirectory @packagesDirectory, ->
				module @, opt
		else
			ui.error "No module to build a repository."

	addToRepository: (target, opt) =>
		module = @modules[@repositoryManager or @packageManager].addToRepository
		if module
			fs.changeDirectory @packagesDirectory, ->
				module @, target, opt

	close: =>
		os.execute "rm -rf '#{@buildingDirectory}'"

	__tostring: =>
		"<pkgxx:Context: #{@pid}-#{@randomKey}>"

	prefixes: {
		"prefix",
		"bindir",
		"sharedir",
		"infodir",
		"mandir",
		"docdir",
		"libdir",
		"libexecdir",
		"includedir",
		"confdir",
		"statedir",
		"opt",
	}

	getPrefix: (name) =>
		defaults = {
			prefix:     "/usr",
			bindir:     "%{prefix}/bin",
			sharedir:   "%{prefix}/share",
			infodir:    "%{sharedir}/info",
			mandir:     "%{sharedir}/man",
			docdir:     "%{sharedir}/doc",
			libdir:     "%{prefix}/lib",
			libexecdir: "%{prefix}/libexec",
			includedir: "%{prefix}/include"
			confdir:    "/etc",
			statedir:   "/var",
			opt:        "/opt"
		}

		@prefixes[name] or defaults[name]

