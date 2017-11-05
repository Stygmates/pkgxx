% PKGXX(1) 2017-11-05 | pkgxx User Manual

# NAME

pkgxx - build application packages for your distribution

# SYNOPSIS

pkgxx [OPTIONS]

# DESCRIPTION

pkgxx is a tool that builds native packages for your current distribution.

It uses a singl, shared recipe file to build those packages in order to reduce the work needed when porting applications from one distribution to another.

pkgxx has modular backends to support various package formats, package sources (aka. repositories), build systems, and so on.

# OPTIONS

-v, \--verbose

:	Increase verbosity.
	This option can be provided several times.

-q, \--quiet

:	Decreases verbosity.
	This option can be provided several times.

-a <arch>, \--arch <arch>

:	Sets the context’s architecture to an arbitrary string.
	This could be useful for cross-compiling setups.

-l, \--lint

:	Print potential defects in the recipe instead of building.


-w, \--watch

:	Checks whether the packages and recipes are up to date and do not build.

-n, \--no-deps

:	Do not build dependencies.

-d, \--deps

:	Check and install dependencies from binary repositories before building

-c <collection>, \--collection <collection>

:	Sets the name of the collection in which the packages are to be built.

	Collections are very experimental and untested.

-t, \--targets

:	Prints the packages described by this recipe and exit.

-f, \--force

:	Force the construction of the packages, even if they are already built and up to date.
	Also replaces the packages in their respective repositories if any.

-h, \--help

:	Show an help message and exit.

# FILES

package.toml

:	Current recipe format.

/etc/pkgxx.conf

:	Configuration file.

# BUGS

There are a lot of minor issues with pkg++.
Most of them are features that are partly implemented.

Support for package managers is also limited.

All bug reports are welcome, and can be send by mail (at <lukc@upyum.com>) or on Github’s bug tracker.

# SEE ALSO

`package.toml`(5)


