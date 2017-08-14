
--- pkgxx’ API exposed as a Moonscript module.
-- @module pkgxx
--
--
--@usage
--	pkgxx = require "pkgxx"
--
--	context = with pkgxx.newContext!
--		.packagesDirectory = os.getenv "HOME"
--
--		recipe = with \openRecipe "package.toml"
--			\download!
--			\build!
--			\package!
--
--		\close!
--
-- @see Context
-- @see Recipe
-- @see Package
---

Context = require "pkgxx.context"

_M = {}

--- Creates a pkgxx context.
-- @function newContext
-- @see Context
_M.newContext = Context

_M

