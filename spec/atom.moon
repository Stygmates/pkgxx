
describe "Atoms", ->
	Atom = require "pkgxx.atom"

	it "parses simple package names", ->
		atom = Atom "name"

		assert.are.same atom.name,   "name"
		assert.are.same atom.origin, "name"

	it "parses package origins", ->
		atom = Atom "name@origin"

		assert.are.same atom.name, "name"
		assert.are.same atom.origin, "origin"

	it "trims whitespace", ->
		atom = Atom "  name   "

		assert.are.same atom.name, "name"
		assert.are.same atom.origin, "name"

	it "checks atoms can be equal", ->
		a = Atom "foo@bar"
		b = Atom "foo@bar"

		assert.are.same a, b

	it "checks atoms can be different", ->
		a = Atom "a@A"
		b = Atom "b@B"

		assert.are.not.same a, b

		a = Atom "a@B"

		assert.are.not.same a, b

