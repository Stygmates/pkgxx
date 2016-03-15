
pkgxx = require "pkgxx"

context = pkgxx.newContext!

recipe = context\openRecipe "package.toml"

recipe\download !
assert recipe\build    !
recipe\package  !
recipe\clean    !

context\close!

