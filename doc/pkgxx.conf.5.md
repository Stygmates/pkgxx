% PKGXX.CONF(5) 2017-11-05 | pkgxx User Manual

# NAME

pkgxx.conf - Configuration file for `pkgxx`(1).

# SYNOPSIS

/etc/pkgxx.conf

# DESCRIPTION

pkgxx can be configured to build various types of packages and to do so for various kinds of operating systems.
Most of its settings and options are initially defined in `pkgxx.conf` (but some of them can be overriden on the command-line).

This configuration file is, in fact, a TOML file.

# COMMON OPTIONS

distribution

:	*String* that contains the name of the distribution for which you are building packages.

	This field is case-sensitive, and most distributions’ name begin with a capital leter.

	Exemple: "Debian"

package-manager

:	*String* that contains the name of the package manager for which you are building packages.

	It does not strictly need to match your `distribution` setting, but you probably want to use your distribution’s package manager nonetheless.
	Unless you don’t.

	Exemple: "dpkg"

repository-manager

:	*String* that contains the name of the tool used to manage and update a packages repository.

	Exemples: "reprepro" on Debian, "apk" on Alpine Linux.

builder

:	*String* that contains the name and email of whoever is using pkgxx.

	Example: "John Smith \<j.smith@example\>"

sources-directory

:	Path to the directory in which you want to store any sources downloaded by pkg++.
	Only unextracted sources (tarballs, patches, etc.) will be stored there.

	Example: "/usr/src"

packages-directory

:	Path to the directory in which you want to store the packages pkg++ will build.
	Any packages repository that pkg++ will maintain will also be stored there.

repository-description

:	Description of your repository.

	The exact semantics of this field depend on your repository manager.
	Some even ignore it.

# DISTRIBUTION-SPECIFIC OPTIONS

distribution-codename

:	Codename of the version of your Debian (or derivative) installation.

	Exemples: "jessie", "stretch", "xenial"

