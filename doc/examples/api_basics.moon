
pkgxx = require "pkgxx"

pwd = do
	p = io.popen "pwd"
	s = p\read "*line"
	p\close!
	s

context = with pkgxx.newContext!
	-- Load pkg++’ default modules.
	-- Custom modules can be loaded or created with \loadModule {}.
	\loadModules!

	-- Some package formats want to know who built them.
	.builder = "Example <example@example>"

	.packageManager = "pacman"
	.distribution = "Arch"

	-- Where to store sources, packages and temporary files.
	.buildingDirectory = "#{pwd}/tmp"
	.packagesDirectory = pwd
	.sourcesDirectory =  pwd

recipe = with context\openRecipe "package.toml"
	\download!
	\build!
	\package!

context\close!

