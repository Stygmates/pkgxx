
--- An atom is a container for a package name and origin.
--
-- Version informations are planned to be added.
--
-- @classmod Atom
---

class
	---
	-- Atoms’ constructor.
	--
	-- @usage
	--   atom = Atom "package@recipeName"
	--   
	--   print atom.name, atom.origin
	--   -- package, recipeName
	--
	-- @tparam string s A string representing a package.
	new: (s) =>
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
	-- @tparam Atom other Any arbitrary Atom.
	__eq: (other) =>
		return @name == other.name and @origin == other.origin

