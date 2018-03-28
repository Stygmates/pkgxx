
{
	name: "Test"

	package:
		target: => "#{@name}::#{@version}::#{@release}"
		build: =>
		install: (filename) -> false

	isInstalled: (name) -> false

	watch: =>
		{
			url: "."
			execute: "echo 1.1.1"
		}

	alterRecipe: =>
		if @class == "library"
			@name = "lib" .. @name
}

