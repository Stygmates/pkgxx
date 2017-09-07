
Class = require "pkgxx.class"

---
-- An atom is a container for a package name and origin.
--
-- Version informations are planned to be added.
---
Class "Atom",
	---
	-- Atoms’ constructor.
	--
	-- ```
	--   atom = Atom "package@recipeName"
	--   
	--   print atom.name, atom.origin
	--   -- package, recipeName
	-- ```
	--
	-- @param s (string) A string representing a package.
	__init: (s) =>
		s = s\gsub "^%s*", ""
		s = s\gsub "%s*$", ""

		if s\match "@"
			@name, @origin = s\match "(%w*)@(%w*)"
		else
			@name = s
			@origin = s

	---
	-- Atoms can be converted to debug strings safely.
	__tostring: =>
		"<Atom: #{@name}@#{@origin}>"

	---
	-- Atoms can be compared for equality.
	--
	-- Their names and origins must be equal for two atoms to be equal.
	--
	-- @param other (Atom) Any arbitrary Atom.
	__eq: (other) =>
		return @name == other.name and @origin == other.origin

