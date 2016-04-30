
toml = require "toml"
argparse = require "argparse"

pkgxx = require "pkgxx"
ui = require "pkgxx.ui"

context = pkgxx.newContext config

context\importConfiguration "/etc/pkgxx.conf"

context\checkConfiguration!

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

	\flag "-l --lint"

	with \option "-c --collection"
		\target "collection"
		\args 1

	\flag "-t --targets"
	\flag "-f --force"

args = parser\parse!

ui.setVerbosity ((4 + ((args.verbosity or 0) - (args.quiet or 0))) or
	context.configuration.verbosity or 4)

if args.architecture
	context.architecture = args.architecture

if args.collection
	print "Building in the following collection: #{args.collection}"
	context.collection = args.collection

recipe = context\openRecipe "package.toml"

if args.lint
	os.exit recipe\lint!

if args.targets
	if not recipe.version
		assert recipe\download!
		recipe\updateVersion!

	for target in recipe\getTargets!
		if ui.getVerbosity! > 3
			ui.detail target
		else
			io.stdout\write target, "\n"

	context\close!

	os.exit 0

local upToDate
if args.force or (not recipe.version) or recipe\buildNeeded!
	recipe\checkDependencies!

	assert recipe\download!

	if not recipe.version
		recipe\updateVersion!

	-- Development packages might have set their versions by now.
	if args.force or recipe\buildNeeded!
		assert recipe\build!
		recipe\package!
		recipe\clean!

		context\updateRepository {
			force: args.force
		}
		context\addToRepository recipe, {
			force: args.force
		}
	else
		upToDate = true
else
	upToDate = true

if upToDate
	ui.info "Everything up to date. Not rebuilding."

context\close!

