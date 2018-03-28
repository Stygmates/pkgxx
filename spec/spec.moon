
file = (path) ->
	f = io.open path, "r"
	content = f\read "*all"
	f\close
	content

describe "spec.parse", ->
	spec = require "pkgxx.spec"

	it "parses declarations", ->
		results = spec.parse file "spec/spec/01-declarations.spec"

		assert.are.same {
			{type: "declaration", variable: "a", value: "1"}
			{type: "declaration", variable: "b", value: "2"}
			{type: "declaration", variable: "c", value: "!!??+-/*<>"}
			{type: "declaration", variable: "d-1", value: "3"}
		}, results

	it "parses sections", ->
		results = spec.parse file "spec/spec/02-sections.spec"

		assert.are.same {
			{type: "section", title: "test", content: "\tcontent is parsed\n\tover several\n\tlines\n\n"}
		}, results

	it "parses declarations of lists", ->
		results = spec.parse file "spec/spec/03-lists.spec"

		assert.are.same {
			{type: "list declaration", variable: "list", values: {
				"list item 1",
				"list item 2 !?+-/*<>"
				"crappy indent 1"
				"no indent 1"
			}}
		}, results

	it "parses modifiers", ->
		pending "not implemented"

		results = spec.parse file "spec/spec/04-modifiers.spec"

		assert.are.same {
			{type: "list declaration", variable: "thing", values: {
				"a", "b", "c", "not-that-one"}
			}
			{type: "declaration", variable: "thing", modifier: "+", value: "something added"}
			{type: "declaration", variable: "thing", modifier: "-", value: "not-that-one"}
		}, results

	-- FIXME: What about inline lists? Do we parse them as such?
	-- FIXME: What about checking syntax errors are *properly* managed?
describe "spec.eval", ->
	spec = require "pkgxx.spec"

	defaultRecipe = "spec/spec/00-recipe-example.spec"
	-- FIXME: Those contexts won’t be closed if the tests fail.
	openRecipe = (filename, f) ->
		unless f
			f = filename
			filename = defaultRecipe

		with context = require("pkgxx").newContext verbosity: 0
			.packageManager = "pkgutils"
			.distribution = "Test"
			.logFile = {write: =>, close: =>}

			success = true

			with recipe, reason = context\newRecipe!
				if recipe
					success, reason = \importSpec filename

				if success
					f recipe, reason
				else
					f nil, reason

			\close!

	it "imports recipes", ->
		openRecipe =>

	it "evaluates macros", ->
		openRecipe =>
			assert.are.same "hello-#{@version}.tar.gz", @sources[1].filename

	it "fails when evaluating unknown macros", ->
		openRecipe "spec/spec/06-broken-macro.spec", (reason) =>
			assert.are.same nil, @
			assert.is.string reason

	it "expands pre-defined variables", ->
		content = file "spec/spec/06-broken-macro.spec"

		result = spec.parse(content)\evaluate {baz: "baz"}

		for element in *result
			if element.variable == "foo"
				assert.are.same "bar-baz", element.value

	it "gets versions and flavors before evaluation", ->
		openRecipe =>
			assert.are.same {"2.10", "2.9", "2.8", "2.7", "2.6"}, @versions
			assert.are.same {"nls", "minimal"}, @flavors

	it "evaluates list modifiers", ->
		pending "not implemented"

	it "parses adequate sections’ body", ->
		pending "not implemented"

