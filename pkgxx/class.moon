
(slots) ->
	unless slots.__index
		slots.__index = slots

	setmetatable slots, {
		__call: (...) =>
			obj = setmetatable {
				__class: slots
			}, slots

			if slots.new
				slots.new obj, ...

			obj
	}

