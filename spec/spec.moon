
describe "spec.parse", ->
	spec = require "pkgxx.spec"

	file = (path) ->
		f = io.open path, "r"
		content = f\read "*all"
		f\close
		content

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
		pending!

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
	it "evaluates", ->
		pending!

	it "evaluates list modifiers", ->
		pending!

	it "parses adequate sections’ body", ->
		pending!

