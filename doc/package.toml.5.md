% PACKAGE.TOML(5) 2017-11-05 | pkgxx User Manual

# NAME

package.toml - recipe for pkgxx

# DESCRIPTION

package.toml is the recipe format for pkgxx.

# MACROS

The `%{macro-name}` syntax can be used in the recipe to substitute other variables within strings.
Some variables are exported from the outside, like `%{prefix}` and `%{pkg}`.

Build instructions *must* install softwares in `%{pkg}`.
Anything installed outside of it may be installed on your system instead of being put in a package.

# FIELDS

name

:	String describing the package’s name.

version

:	String containing the packaged software’s version.

	Can be left empty if one of the sources is a git repository (or a URL pointing to any other SCM repository that pkgxx understands).

release

:	Integer containing the package’s version.

	If missing, a default value of `1` will be used.

sources

:	An array of strings containing URLs to the resources needed to build a software.

	Each entry can use an arrow notation to locally rename the downloaded tarball:

		`"http://example -> %{name}-%{version}.tar.gz"`

	Arrows can be usefull to avoid collisions.

configure

:	An array of strings or a long string that describes the shell commands used to configure the software.

build

:	An array of strings or a long string that describes the shell commands used to build the software.

install

:	An array of strings or a long string that describes the shell commands used to install the software.

# FUTURE

This format is likely to be replaced in the future.
Compatibility with it will be kept, probably for a long time.
It will however not receive updated related to new pkgxx features at that point.

# SEE ALSO

`pkgxx`(1)

