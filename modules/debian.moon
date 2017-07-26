
ui = require "pkgxx.ui"

{
	name: "Debian",
	alterRecipe: =>
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
	autosplits: =>
		name = @splits[1].name
		description = @splits[1].description

		{
			{
				name: name .. "-dev",
				summary: "Development files for #{@name}"
				description: "#{description}\n\nThis package contains the header files and static libraries needed to compile applications or shared objects that use #{@name}."
				files: { "%{includedir}" }
				options: {"no-arch"}
			}
		}
}

