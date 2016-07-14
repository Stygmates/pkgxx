
pkgxx = require "pkgxx"
ui = require "pkgxx.ui"

context = pkgxx\newContext!

ui.setVerbosity 0

for name, module in pairs context.modules
	describe "modules.#{name}:", ->
		local doesSomething

		it "has a name", -> assert module.name

		-- package manager support
		if module.package
			doesSomething = true

			describe "package manager module", ->
				it "builds packages", ->
					assert module.package.target
					assert module.package.build

				it "installs packages", ->
					assert module.package.install

				it "checks installed packages", ->
					assert module.package.isInstalled

		if module.download
			doesSomething = true

			describe "sources module", ->

		if module.getVersion
			doesSomething = true

			describe "VCS sources module", ->

			it "clones repositories", ->
				assert module.download

		if module.configure or module.build or module.install
			doesSomething = true

			describe "build system module", ->

			if module.configure
				it "configures", ->
					assert module.canConfigure

			if module.build
				it "builds", ->
					assert module.canBuild

			if module.install
				it "installs", ->
					assert module.canInstall

		if module.autosplits or module.alterRecipe
			doesSomething = true

		if module.makeRepository
			doesSomething = true

			it "adds packages to repositories without full rebuilds", ->
				assert module.addToRepository

		if module.installDependency
			doesSomething = true

		it "does something", -> assert doesSomething

context\close!

