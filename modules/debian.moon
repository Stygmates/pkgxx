
ui = require "pkgxx.ui"

{
	name: "Debian",
	alterRecipe: =>
		unless @class
			ui.warning "" ..
				"Debian packages should all have a 'class' value!"
			return

		switch @class
			when "library"
				@name = "lib" .. @name
				@name = @name\gsub "^liblib", "lib"
			when "headers"
				@name = @name .. "-dev"
				@name = @name\gsub "-dev-dev$", "-dev"
			when "documentation"
				@name = @name .. "-doc"
				@name = @name\gsub "-doc-doc$", "-doc"
			when "binary"
				true -- Do nothing.
			else
				ui.warning "<modules/Debian> Unrecognized class: " ..
					"'#{@class}'"
}
