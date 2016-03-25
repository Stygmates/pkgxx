
toml = require "toml"
argparse = require "argparse"

pkgxx = require "pkgxx"
ui = require "pkgxx.ui"

context = pkgxx.newContext config

context\importConfiguration "/etc/pkgxx.conf"

parser = with argparse "pkgxx", "Packages builder."
	with \argument "recipe",
		"Path to the recipe of the package to build."
		\args "?"

	with \flag "-v --verbose"
		\count "0-2"
		\target "verbosity"

	with \flag "-q --quiet"
		\count "0-3"
		\target "quiet"

	with \option "-a --arch"
		\target "architecture"
		\args 1

	\flag "-t --targets"
	\flag "-f --force"

args = parser\parse!

ui.setVerbosity ((4 + ((args.verbosity or 0) - (args.quiet or 0))) or
	context.configuration.verbosity or 4)

if args.architecture
	context.architecture = args.architecture

recipe = context\openRecipe "package.toml"

if args.targets
	for target in recipe\getTargets!
		if ui.getVerbosity! > 3
			ui.detail target
		else
			io.stdout\write target, "\n"

	context\close!

	os.exit 0

if args.force or recipe\buildNeeded!
	recipe\download!
	assert recipe\build!
	recipe\package!
	recipe\clean!

	context\updateRepository!
	context\addToRepository recipe
else
	ui.info "Everything up to date. Not rebuilding."

context\close!

