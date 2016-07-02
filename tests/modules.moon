
pkgxx = require "pkgxx"
ui = require "pkgxx.ui"

context = pkgxx\newContext!

ui.setVerbosity 0

for name, module in pairs context.modules
	describe "modules.#{name}:", ->
		it "has a name", -> assert module.name

		-- package manager support
		if module.target
			describe "package manager support", ->
				it "builds packages", ->
					assert module.package

				it "installs packages", ->
					assert module.installPackage

				it "checks installed packages", ->
					assert module.isInstalled

		if module.download
			describe "sources downloader", ->

		if module.getVersion
			describe "VCS support", ->

			it "clones repositories", ->
				assert module.download

		if module.configure or module.build or module.install
			describe "build system support", ->

			if module.configure
				it "configures", ->
					assert module.canConfigure

			if module.build
				it "builds", ->
					assert module.canBuild

			if module.install
				it "installs", ->
					assert module.canInstall

context\close!

