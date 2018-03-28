
---
-- TODO: 
--   - Testing \download will also require a dedicated download module.
--   - Testing \build and \package WILL be difficult through busted.
---

testContext = ->
	pkgxx = require "pkgxx"

	-- FIXME: Guessing several values for Context takes time
	--        (pid, architecture, etc.). Providing test values
	--        would speed up the associated tests. Would be nice.
	with pkgxx.newContext!
		.packageManager = "Test"
		.distribution = "Test"

		.logFile = io.stderr

---
-- Creates a recipe, runs code over it, and then cleans and closes
-- the test Context.
testRecipe = (f) ->
	with testContext!
		success, reason = pcall ->
			recipe = \newRecipe!
			f recipe

		\close!

		unless success
			error reason, 0

describe "Recipe", ->
	-- Basic API checks.
	it "creates empty Recipes from empty Contexts", ->
		testRecipe =>
			@name = "test"

			assert.is.true @\finalize!

			assert.are.same 1,  @release
			assert.are.same {}, @sources
			assert.are.same {}, @buildDependencies

	it "fails to finalize if critical fields are missing", ->
		testRecipe =>
			assert.is.nil @\finalize!

	it "creates automatically a main package", ->
		testRecipe =>
			@name = "Test"
			@version = "1.0.0"
			@release = 1

			@\finalize!

			assert.are.same "Test",  @packages[1].name
			assert.are.same "1.0.0", @packages[1].version
			assert.are.same 1,       @packages[1].release

	it "allows new sources to be manually added", ->
		Source = require "pkgxx.source"

		testRecipe =>
			@name = "Test"

			@\addSource "file:///test.1"

			@\addSource Source
				url: "file:///test.2"
				protocol: "file"
				filename: "test.2"

			@\finalize!

			for i, source in ipairs @sources
				assert.are.same "file", source.protocol
				assert.are.same "test.#{i}", source.filename
				assert.are.same "file:///test.#{i}", source.url

	it "allows sub-packages to be manually defined", ->
		testRecipe =>
			@name = "Test"
			@version = "1.0.0"
			@release = 1

			with @\addPackage "Sub-test"
				.version = "0.8.2"

			@\finalize!

			assert.are.same "Test",     @packages[1].name
			assert.are.same "Sub-test", @packages[2].name

	it "autoguesses @watch on finalization", ->
		testRecipe =>
			@name = "Test"

			@\finalize!

			assert.are.same @context.modules.Test.watch(@), @watch

	it "alters packages to match distribution rules", ->
		testRecipe =>
			@name = "Test"

			@packages[1].class = "binary"

			with @\addPackage "test"
				.class = "library"

			@\finalize!

			assert.are.same "libtest", @packages[2].name

