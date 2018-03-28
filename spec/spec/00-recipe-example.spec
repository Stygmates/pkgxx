
name:     hello
version:  2.10
versions: 2.10, 2.9, 2.8, 2.7, 2.6
sources:
  - https://ftp.gnu.org/gnu/hello/hello-%{version}.tar.gz

packager: Luka Vandervelden <lukc@upyum.com>
url:      https://www.gnu.org/software/hello/

flavors: nls, minimal

@configure
	cd hello-%{version}
	./configure

@build
	cd hello-%{version}
	make

@install
	cd hello-%{version}
	make DESTDIR="$PKG" install

