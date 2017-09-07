
Context = require "pkgxx.context"

---
-- # Introduction
--
-- pkg++ is a very modular packaging tool that can be used both from the command-line or from scripts.
-- This part of the documentation will deal mostly about pkg++’ Moonscript API, which exposes *all* of pkg++’ features, from reading recipes to building packages and repositories.
--
-- Being written in Moonscript, that API is also available in Lua (after a call of `require "moonscript"`), but the details of using Moonscript code from Lua are not the purpose of this document.
--
-- # Basic usage
--
-- Most people reading this document will be interested mostly in reading recipes and building packages.
-- The following example code does just that.
--
-- ```moon
-- pkgxx = require "pkgxx"
--
-- context = with pkgxx.newContext!
-- 	\loadModules!
--
-- 	.packageManager = "dpkg"
-- 	.distribution = "Debian"
--
-- 	.packagesDirectory = os.getenv "HOME"
--
-- 	recipe = with \openRecipe "package.toml"
-- 		\download!
-- 		\build!
-- 		\package!
--
-- 	\close!
-- ```
--
-- What this example does is basically the following:
--
--   - Create and configure a pkg++ Context.
--   - Create and fill-in a Recipe.
--   - Build everything.
--   - Close the context (which closes and remove temporary files).
--
-- This example uses the short and simple API, which automates most of the detailed operations going on.
-- For example, the call to `loadModules` loads all pkg++ modules in the system.
-- This provides support for most package managers and features users will want, but if for some reason you desire to have a minimal and completely controlled environment, loading modules by hand (or even creating them dynamically!) remains possible.
--
-- @see Context
-- @see Recipe
-- @see Package
---
{
	--- Wrapper around Context.
	-- @return Context
	newContext: (...) -> Context ...
}

