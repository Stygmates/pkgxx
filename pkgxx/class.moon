
---
-- @classmod Class
--
-- A homemade class system, designed to use metatables extensively and to be extremely dynamic.
-- 
-- Differences with moonscript’s builtin class:
-- 
--   - __init instead of new
--   - `getmetatable(instance)` instead of `instance.__class`
--   - Instances can be called if `__call` is defined in their class.
--   - No built-in inheritance mechanism, but __index can be set.
--   - class variables are defined through the __class array, and not through `@variable:` definitions.
--
-- @usage
-- MyClass = Class
-- 	__init: (arg) =>
-- 		self.value = arg.value
-- 
-- 	print: =>
-- 		print self.value
--    
-- myInstance = MyClass value: 3.14
--    
-- myInstance\print!
-- -- 3.14
-- 
-- -- Static class attributes.
-- Static = Class
-- 	__class: {
-- 		Foo: 42
-- 	}
-- 
-- print Static.Foo
-- -- 42
---

---
-- @attribute __name
---

---
-- @attribute __call
---

---
-- @attribute __index
---

---
-- @attribute __tostring
---

ClassData = (_class, data) ->
	data or= {}

	setmetatable data,
		__tostring: =>
			"<ClassData: #{_class}>"

	data

Class = setmetatable {},
	__tostring: => "<Class>"
	__call: (name, def) =>
		-- FIXME: Using debug may prove more useful.
		if type(name) == "table"
			def = name
		elseif type(name) == "string"
			def.__name or= name

		unless def.__tostring
			def.__tostring = =>
				"<#{def.__name or "(anonymous)"}>"

		unless def.__index
			def.__index = (key) =>
				__getters = def.__getters
				if __getters
					getter = __getters[key]

					if getter
						return getter self

				value = rawget self, key

				if value
					return value

				value = def[key]

				if value
					return value

		unless def.__newindex
			def.__newindex = (key, value) =>
				__setters = def.__setters
				if __setters
					setter = __setters[key]

					if setter
						return setter self, value

				rawset self, key, value

		__class = ClassData def, def.__class

		__class.__call or= def.__construct or (...) =>
			instance = setmetatable {}, def

			if def.__init
				def.__init instance, ...

			instance

		__class.__index or= (key) =>
			value = rawget self, key

			if value
				return value

			__class = rawget self, "__class"
			if __class
				value = rawget __class, key

				if value
					return value

		-- erroring __new_index ?

		__class.__tostring or= =>
				"<Class: #{def.__name or "(anonymous)"}>"

		setmetatable def, __class

Class

