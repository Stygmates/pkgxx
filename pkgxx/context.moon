
moonscript = require "moonscript"
toml = require "toml"

ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

{:setfenv} = require "moonscript.util"

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
	new: (arg) =>
		arg or= {}

		@verbosity = arg.verbosity or 4

		pid = -666 -- Default value if /proc is unavailable.
		stat = io.open "/proc/self/stat", "r"
		if stat
			pid = tonumber ((stat\read "*line")\gsub " .*", "")
			stat\close!

		@randomKey = math.random 0, 65535

		-- Those two should be set to strings in the configuration.
		@sourcesDirectory  = nil
		@packagesDirectory = nil

		@buildingDirectory = "/tmp/pkgxx-#{pid}-#{@randomKey}"

		@\setLogFile "/var/log/pkgxx/#{pid}-#{@randomKey}.log"

		@collections = {}

		@compressionMethod = "gz"
		@prefixes = [p for p in *@prefixes] -- Cloning.

		-- Array of strings that contain the pathnames of the repositories
		-- in which pkg++ could look for dependencies.
		@repositories = {}

		-- An associative array of stuff to export when running
		-- external commands in order to build softwares.
		@environment = {}

		-- Setting default architecture based on the machine’s real
		-- architecture.
		p = io.popen "uname -m"
		@architecture = p\read "*line"
		p\close!

		fs.mkdir @buildingDirectory

		@\loadModules!

	---
	-- Loads the system-wide pkg++ configuration, usually stored in `/etc/pkg++.conf`.
	--
	-- @param filename (string) Path to a configuration file to load instead of the default one.
	-- @return nil
	importConfiguration: (filename) =>
		chunk, reason = moonscript.loadfile filename

		unless chunk
			reason = reason\gsub "Failed to parse:", "#{filename}: syntax error"

			error reason, 0

		environment = with {}
			for k, v in pairs _G
				[k] = v

			.context = self
			.prefixes = @prefixes
			.environment = @environment

		setfenv chunk, environment

		chunk!

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

					@\debug "Loading module '#{filename}'."

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

	setLogFile: (path) =>
		@logFilePath = path
		if path
			dirname = path\gsub("/[^/]*$", "")
			fs.mkdir dirname

			@logFile = io.open @logFilePath, "w"

		unless @logFile
			@logFilePath = nil
			@logFile =
				write: =>
				close: =>

			return nil, "could not open create logs directory"
		else
			return @logFile, @logFilePath

	moveLogFile: (newPath) =>
		unless @logFilePath
			return

		if fs.execute context:self, "mv '#{@logFilePath}' '#{newPath}'"
			@logFilePath = newPath

	---
	-- Prints warnings on stderr if important configuration elements are missing.
	--
	-- @return nil
	checkConfiguration: =>
		checks = {}
		Check = (arg) -> table.insert checks, arg

		Check
			message:  "context.packagesDirectory is not set"
			function: => type(@packagesDirectory) == "string"
		Check
			message:  "context.sourcesDirectory is not set"
			function: => type(@sourcesDirectory) == "string"
		Check
			message:  "context.packageManager does not designate a package manager backend"
			function: => @modules[@packageManager] != nil
		Check
			message:  "context.repositoryManager does not designate a repository manager backend"
			function: => (not @repositoryManager) or @modules[@repositoryManager] != nil

		failures = 0
		for check in *checks
			unless check.function self
				@\error check.message
				failures += 1

		failures == 0

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
	openRecipe: (filename = "package.toml", version = nil, flavor = nil) =>
		with @\newRecipe @
			if filename\match "%.toml$"
				\importTOML filename
			else
				\importSpec filename, version, flavor
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

		module.isInstalled self, atom.name, atom

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
			@\error "No module to build a repository."

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

	debug: (...) =>
		if @verbosity >= 6
			ui.debug io.stdout, ...
		ui.debug @logFile, ...
	detail: (...) =>
		if @verbosity >= 4
			ui.detail io.stdout, ...
		ui.detail @logFile, ...
	info: (...) =>
		if @verbosity >= 3
			ui.info io.stdout, ...
		ui.info @logFile, ...
	section: (...) =>
		if @verbosity >= 2
			ui.section io.stdout, ...
		ui.section @logFile, ...
	warning: (...) =>
		if @verbosity >= 2
			ui.warning io.stderr, ...
		ui.warning @logFile, ...
	error: (...) =>
		if @verbosity >= 1 -- Aww man, don’t go below that.
			ui.error io.stderr, ...
		ui.error @logFile, ...

