
toml = require "toml"
pkgxx = require "pkgxx"
ui = require "pkgxx.ui"

configFileName = "/etc/pkgxx.conf"
configFile = io.open configFileName, "r"

local config
if configFile
	config = toml.parse configFile\read "*all"
	configFile\close!
else
	ui.warning "No configuration file found at '#{configFileName}'."

unless config
	config = {}

ui.setVerbosity (config.verbosity or 4)

context = pkgxx.newContext config

recipe = context\openRecipe "package.toml"

recipe\download!
assert recipe\build!
recipe\package!
recipe\clean!

context\close!

