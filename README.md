
# pkg++

pkg++ builds packages native to your distribution by reading recipes or data from various sources.

pkg++ is written in Moonscript.

## Executable usage

```
Usage: pkgxx [-v] [-q] [-a <arch>] [-l] [-w] [-n] [-d]
	   [-c <collection>] [-t] [-f] [-h] [<recipe>]

Packages builder.

Arguments:
   recipe                Path to the recipe of the package to build.

Options:
   -v, --verbose
   -q, --quiet
   -a <arch>, --arch <arch>
   -l, --lint            Print potential defects in the recipe instead of building.
   -w, --watch           Only checks whether the packages and recipes are up to date.
   -n, --no-deps         Do not build dependencies.
   -d, --deps            Check and install dependencies before building
   -c <collection>, --collection <collection>
   -t, --targets
   -f, --force           Force rebuild and repository inclusion.
   -h, --help            Show this help message and exit.
```

## Library usage

pkg++ is designed to be usable as a Moonscript library upon which packaging tools can be built.

Examples of uses for such a library include:

  - automated imports from other repositories (language-level package management, other distributions, …);
  - scripted builds (automated testing, automated deployment, …);
  - integration within other tools, possibly packaging tools.

API documentation can be generated with LDoc (`ldoc -X .`).
That documentation is however likely incomplete.

```moonscript
pkgxx = require "pkgxx"

pwd = do
	p = io.popen "pwd"
	s = p\read "*line"
	p\close!
	s

context = with pkgxx.newContext!
	-- Load pkg++’ default modules.
	-- Custom modules can be loaded or created with \loadModule {}.
	\loadModules!

	-- Some package formats want to know who built them.
	.builder = "Example <example@example>"

	.packageManager = "pacman"
	.distribution = "Arch"

	-- Where to store sources, packages and temporary files.
	.buildingDirectory = "#{pwd}/tmp"
	.packagesDirectory = pwd
	.sourcesDirectory =  pwd

recipe = with context\openRecipe "package.toml"
	\download!
	\build!
	\package!

context\close!
```

## package.toml example

`package.spec` is the WIP recipe format for pkg++.

Work will be invested to support multiple recipe formats in the future.

```spec
name:     hello
version:  2.10
source:   https://ftp.gnu.org/gnu/hello/hello-%{version}.tar.gz

packager: Luka Vandervelden <lukc@upyum.com>
url:      https://www.gnu.org/software/hello/

dependencies:
- gettext
- ncurses

@configure
	cd hello-%{version}
	./configure

@build
	cd hello-%{version}
	make

@install
	cd hello-%{version}
	make DESTDIR="%{pkg}" install

# Optionnal section to watch for upstream updates!
@watch
	url: https://ftp.gnu.org/gnu/hello/
	lasttar: hello-

```

## Dependencies

  - [Moonscript](https://moonscript.org/)
  - [lua-toml](https://github.com/jonstoler/lua-toml)
  - [lua-argparse](https://github.com/mpeterv/argparse)
  - [luafilesystem](https://github.com/keplerproject/luafilesystem)
  - [build.zsh](https://github.com/Lukc/build.zsh)
  - [lua-process](https://github.com/mah0x211/lua-process)
  - [lua-split](https://github.com/moteus/lua-split)

