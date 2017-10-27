
moonscript = require "moonscript"
toml = require "toml"

ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

Recipe = require "pkgxx.recipe"
Module = require "pkgxx.module"

loadstring = loadstring or load

---
-- pkgxx’ main class.
--
-- The Context is a shared environment in which packages are built with
-- a specific configuration and for a given package manager.
--
-- Its most-used method is probably [newRecipe](#newRecipe).
---
class Context
	---
	-- Context constructor.
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

		fs.mkdir "/var/log/pkgxx"
		@logFilePath = "/var/log/pkgxx/#{pid}-#{@randomKey}.log"

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

		@logFile = io.open @logFilePath, "w"

		@\loadModules!

	---
	-- Loads the system-wide pkg++ configuration, usually stored in `/etc/pkg++.conf`.
	--
	-- @param filename (string) Path to a configuration file to load instead of the default one.
	-- @return nil
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

		@repositoryDescription = configuration["repository-description"]

		for variable in *{
			"CFLAGS", "CPPFLAGS", "CXXFLAGS", "FFLAGS", "LDFLAGS",
			"MAKEFLAGS"
		}
			if configuration[variable]
				@exports[variable] = configuration[variable]

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

	---
	-- Loads the default pkg++ modules, installed in the system directories.
	-- Those directories are usually `/usr/share/pkgxx` and its `/usr/local` variant.
	--
	-- @issue Broken modules will likely throw errors.
	-- @warning Modules from the `./modules` directories are also currently loaded, for development reasons.
	--
	-- @return nil
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
						content = code!
						content.name = content.name or name

						@\loadModule content
					else
						io.stderr\write "module '#{name}' not loaded: #{e}\n"

	---
	-- Creates a module and loads it into the Context.
	--
	-- This methods allows the dynamic creation of modules in pkg++.
	--
	-- @param content (table) Module content.
	-- @return nil
	--
	-- @see Module
	loadModule: (content) =>
		module = Module content
		@modules[module.name] = module

		if module.name and not @modules[module.name]
			@modules[module.name] = module

	---
	-- Prints warnings on stderr if important configuration elements are missing.
	--
	-- @return nil
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

	---
	-- Creates a new empty Recipe object.
	--
	-- The only difference with the default Recipe constructor is that the current Context is provided.
	--
	-- @return (Recipe)
	newRecipe: =>
			Recipe @

	---
	-- Creates a Recipe object from a package.toml file.
	--
	-- @param filename (string) Filename of the package.toml to read and parse into a Recipe.
	-- @see Recipe
	--
	-- @warning This method is deprecated. Use newRecipe instead.
	openRecipe: (filename = "package.toml") =>
		with @\newRecipe @
			\importTOML filename
			\finalize!

	---
	-- Asks the package manager whether a given package Atom is installed.
	--
	-- @param atom (Atom) Atom describing a package whose installation is being tested.
	-- @return (boolean) Whether the atom installed or not.
	-- @see Atom
	isAtomInstalled: (atom) =>
		module = @modules[@packageManager]

		unless module and module.isInstalled
			-- FIXME: Make this a real warning once it’s implemented.
			return nil, "unable to check dependencies"

		module.isInstalled atom.name, atom

	---
	-- Updates the context’s packages repository.
	--
	-- It can be used to register several new packages at once.
	--
	-- @param opt (table) Options to provide to the repository manager’s module.
	--
	-- @return (boolean) Value returned by the repository manager’s module.
	-- @return (nil) No module could be used to update the repository.
	updateRepository: (opt) =>
		unless @repositoryManager
			return

		module = @modules[@repositoryManager or @packageManager].makeRepository
		if module
			fs.changeDirectory @packagesDirectory, ->
				module @, opt
		else
			ui.error "No module to build a repository."

	---
	-- Adds a package to the context’s repository.
	--
	-- @param target (string) Filename of the package to add to the repository.
	-- @param opt (table) Options to provide to the repository manager’s module.
	--
	-- @return (boolean) Value returned by the repository manager’s module.
	-- @return (nil) No module could be used to update the repository.
	addToRepository: (target, opt) =>
		module = @modules[@repositoryManager or @packageManager].addToRepository
		if module
			fs.changeDirectory @packagesDirectory, ->
				module @, target, opt

	log: (...) =>
		@logFile\write ...

	---
	-- Closes the context.
	--
	-- @warning This method removes the context's temporary files.
	close: =>
		@logFile\close!
		os.execute "rm -rf '#{@buildingDirectory}'"

	__tostring: =>
		"<pkgxx:Context: #{@pid}-#{@randomKey}>"

	---
	-- Array of prefix names.
	-- Used for macro substitutions and for some auto-configuration within modules.
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

	---
	-- Gets the current path for a specific prefix.
	--
	-- @param name (string) One of the values in @prefixes.
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

