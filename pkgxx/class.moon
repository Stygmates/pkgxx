
(arg) ->
	unless arg.__index
		arg.__index = arg

	setmetatable arg, {
		__call: (...) =>
			obj = setmetatable {
				__class: arg
			}, arg

			if arg.new
				arg.new obj, ...

			obj
	}

