
toml = require "toml"
argparse = require "argparse"

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

parser = with argparse "pkgxx", "Packages builder."
	with \argument "recipe",
		"Path to the recipe of the package to build."
		\args "?"

	with \flag "-v --verbose"
		\count "0-1"
		\target "verbosity"

	with \flag "-q --quiet"
		\count "0-3"
		\target "quiet"

	with \option "-a --arch"
		\target "architecture"
		\args 1

	\flag "-t --targets"

args = parser\parse!

ui.setVerbosity ((4 + ((args.verbosity and 1 or 0) - (args.quiet or 0))) or
	config.verbosity or 4)

context = pkgxx.newContext config

if args.architecture
	context.architecture = args.architecture

for variable in *{
	"CFLAGS", "CPPFLAGS", "CXXFLAGS", "FFLAGS", "LDFLAGS",
	"MAKEFLAGS"
}
	if config[variable]
		context.exports[variable] = config[variable]

recipe = context\openRecipe "package.toml"

if args.targets
	for target in recipe\getTargets!
		if ui.getVerbosity! > 3
			ui.detail target
		else
			io.stdout\write target, "\n"

	context\close!

	os.exit 0

recipe\download!
assert recipe\build!
recipe\package!
recipe\clean!

context\close!

