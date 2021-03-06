
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
				@context\warning "<modules/Fedora> Unrecognized class: '#{@class}'."
	autosplits: =>
		name = @splits[1].name
		description = @splits[1].description

		{
			{
				name: name .. "-devel",
				summary: "Development files for #{@name}",
				description: description
				files: { "%{includedir}" }
			}
		}
}

