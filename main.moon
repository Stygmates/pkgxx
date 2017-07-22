#!/usr/bin/env moon

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

	\flag "-l --lint",
		"Print potential defects in the recipe instead of building."

	\flag "-w --watch",
		"Only checks whether the packages and recipes are up to date."

	\flag "-n --no-deps", "Do not build dependencies."

	\flag "-d --deps", "Check and install dependencies before building"

	with \option "-c --collection"
		\target "collection"
		\args 1

	\flag "-t --targets"
	\flag "-f --force", "Force rebuild and repository inclusion."

args = parser\parse!

ui.setVerbosity ((4 + ((args.verbosity or 0) - (args.quiet or 0))) or
	context.configuration.verbosity or 4)

if args.architecture
	context.architecture = args.architecture

if args.collection
	print "Building in the following collection: #{args.collection}"
	context.collection = args.collection

success, recipe = pcall -> context\openRecipe "package.toml"

unless success
	with reason = recipe
		ui.error "Could not open recipe."
		ui.error tostring reason

		os.exit 1

if args.lint
	count = recipe\lint!
	context\close!
	os.exit count
elseif args.watch
	if not recipe.version
		recipe\updateVersion!

	if not recipe.version
		ui.warning "no sources, no version information"
		os.exit 3
	elseif not recipe.watch
		if recipe\buildNeeded!
			ui.warning "no watch, build needed"
		else
			ui.warning "no watch"
		os.exit 2
	else
		upToDate, lastVersion = recipe\isUpToDate!

		if upToDate
			ui.info "up to date, version is #{lastVersion}"
			os.exit 0
		else
			ui.warning "outdated recipe, version is #{recipe.version} but should be #{lastVersion}"
			os.exit 1

local uid, gid

with io.popen "id -u"
	uid = tonumber \read "*line"
	\close!

with io.popen "id -g"
	gid = tonumber \read "*line"
	\close!

unless args.targets or args.lint
	if uid ~= 0 or gid ~= 0
		-- I’d sure like to get rid of that warning, though.
		ui.error "You should build your packages as root."
		ui.error "Not doing so will result in errors or invalid packages."

if args.targets
	if not recipe.version
		unless recipe\download!
			ui.error "The download has failed."

			os.exit 1

		recipe\updateVersion!

	for target in recipe\getTargets!
		if ui.getVerbosity! > 3
			ui.detail target
		else
			io.stdout\write target, "\n"

	context\close!

	os.exit 0

revertTable = (t) -> [t[i] for i = #t, 1, -1]

packagesList = if args.no_deps
	{recipe}
else
	revertTable recipe\depTree!

if #packagesList > 1
	ui.section "Build list:"
	for recipe in *packagesList
		ui.detail "  - " ..
			"#{recipe.name}-#{recipe.version or "%"}-#{recipe.release}"

local upToDate
for recipe in *packagesList
	if args.force or (not recipe.version) or recipe\buildNeeded!
		if args.deps
			recipe\checkDependencies!

		if #packagesList > 1
			ui.section "Building " ..
				"#{recipe.name}-#{recipe.version or "%"}-#{recipe.release}."

		if recipe.version and recipe.watch
			ui.info "Checking if recipe is up to date…"

			r, ver, e = recipe\isUpToDate!

			unless r
				if e
					ui.warning "Could not check whether this recipe is up to date."
				else
					ui.warning "A new version was published since this recipe was written!"
					ui.warning "The version guessed is the following: #{ver}"
			else
				ui.detail "Recipe seems up to date."

		unless recipe\download!
			ui.error "The download has failed."

			os.exit 1

		if not recipe.version
			recipe\updateVersion!

		-- Development packages might have set their versions by now.
		if args.force or recipe\buildNeeded!
			unless recipe\build!
				ui.error "You may want to look in the logs for more details."
				ui.error "Log file: #{recipe\getLogFile!}"

				os.exit 1

			recipe\package!
			recipe\clean!

			context\updateRepository {
				force: args.force
			}

			for split in *recipe.splits
				-- FIXME: Should we check it’s been actually built instead?
				if split.automatic and not split\hasFiles!
					continue

				context\addToRepository split, {
					force: args.force
				}
		else
			upToDate = true
	else
		upToDate = true

if upToDate
	ui.info "Everything up to date. Not rebuilding."

context\close!

