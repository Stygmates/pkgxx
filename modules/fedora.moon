
ui = require "pkgxx.ui"

{
	name: "Fedora",
	alterRecipe: =>
		switch @class
			when "headers"
				@name = @name .. "-devel"
				@name = @name\gsub "-devel-devel", "-devel"
			when "documentation"
				@name = @name .. "-doc"
				@name = @name\gsub "-doc-doc$", "-doc"
			when "library"
				true -- Do nothing.
			when "binary"
				true -- Do nothing.
			else
				ui.warning "<modules/Fedora> Unrecognized class: '#{@class}'."
	autosplits: =>
		{
			{
				name: @name .. "-devel",
				description: "Development files for #{@name}",
				files: { "%{includedir}" }
			}
		}
}

