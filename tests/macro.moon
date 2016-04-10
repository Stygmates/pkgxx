
describe "pkgxx.macro", ->
	ui = require "pkgxx.ui"
	-- Disabled to remove those “undefined variable” things.
	ui.warning = ->

	macro = require "pkgxx.macro"

	it "replaces simple variables", ->
		assert "works" == macro.parseString "w%{xxx}s", {xxx: "ork"}

	it "works with the short syntax", ->
		assert "works" == macro.parseString "w%orks", {orks: "orks"}

	it "ignores undefined variables", ->
		assert "works" == macro.parseString "work%{notfound}s", {}

	it "replaces recursive variables", ->
		assert "works" == macro.parseString "w%{xxx}s", {
			xxx: "o%{yyy}k",
			yyy: "r"
		}
		
	it "works on tables", ->
		t = macro.parse {
			"w%{x}s",
			"wo%{r}ks"
		}, {
			x: "ork",
			r: "r"
		}

		for e in *t
			assert e == "works"


