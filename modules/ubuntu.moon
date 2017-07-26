
ui = require "pkgxx.ui"

{
	name: "Ubuntu",
	alterRecipe: (recipe, ...) =>
		if not recipe.os.Ubuntu
			@\applyDistributionDiffs recipe, "Debian"

		@context.modules.Debian.alterRecipe self, recipe, ...
	autosplits: (...) =>
		@context.modules.Debian.autosplits self, ...
}

