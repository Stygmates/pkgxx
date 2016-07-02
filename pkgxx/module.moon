
class
	new: (arg) =>
		for key, value in pairs arg
			@[key] = value

	__tostring: => "<pkgxx:Module #{@name}>"

