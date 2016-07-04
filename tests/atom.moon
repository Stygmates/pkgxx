
describe "Atoms", ->
	Atom = require "pkgxx.atom"

	it "parses simple package names", ->
		atom = Atom "name"

		assert atom.name == "name"
		assert atom.origin == "name"

	it "parses package origins", ->
		atom = Atom "name@origin"

		assert atom.name == "name"
		assert atom.origin == "origin"

	it "trims whitespace", ->
		atom = Atom "  name   "

		assert atom.name == "name"
		assert atom.origin == "name"

	it "checks atoms can be equal", ->
		a = Atom "foo@bar"
		b = Atom "foo@bar"

		assert a == b

	it "checks atoms can be different", ->
		a = Atom "a@A"
		b = Atom "b@B"

		assert a != b

		a = Atom "a@B"

		assert a!= b

