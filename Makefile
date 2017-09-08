PACKAGE = 'pkgxx'
VERSION = '0.2.0'

PREFIX := /usr/local
BINDIR := $(PREFIX)/bin
LIBDIR := $(PREFIX)/lib
SHAREDIR := $(PREFIX)/share
INCLUDEDIR := $(PREFIX)/include
LUA_VERSION := 5.1

CC := cc
AR := ar
RANLIB := ranlib
CFLAGS := 
LDFLAGS := 

Q := @

all: pkgxx/atom.moon pkgxx/builder.moon pkgxx/class.moon pkgxx/context.moon pkgxx/fs.moon pkgxx/macro.moon pkgxx/module.moon pkgxx/package.moon pkgxx/recipe.moon pkgxx/source.moon pkgxx/ui.moon pkgxx.moon modules/apk.moon modules/apt.moon modules/autotools.moon modules/build.zsh.moon modules/cmake.moon modules/createrepo.moon modules/debian.moon modules/dnf.moon modules/dpkg.moon modules/fedora.moon modules/ftp.moon modules/github.moon modules/git.moon modules/http.moon modules/https.moon modules/make.moon modules/man.moon modules/ownership.moon modules/pacman.moon modules/perl.moon modules/pkgutils.moon modules/reprepro.moon modules/rpm.moon modules/strip.moon modules/ubuntu.moon modules/vim.moon modules/waf.moon main
	@:

pkgxx/atom.moon:

pkgxx/atom.moon.install: pkgxx/atom.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/atom.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx'
	$(Q)install -m0755 pkgxx/atom.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/atom.moon

pkgxx/atom.moon.clean:

pkgxx/atom.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/atom.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/atom.moon'

pkgxx/builder.moon:

pkgxx/builder.moon.install: pkgxx/builder.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/builder.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx'
	$(Q)install -m0755 pkgxx/builder.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/builder.moon

pkgxx/builder.moon.clean:

pkgxx/builder.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/builder.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/builder.moon'

pkgxx/class.moon:

pkgxx/class.moon.install: pkgxx/class.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/class.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx'
	$(Q)install -m0755 pkgxx/class.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/class.moon

pkgxx/class.moon.clean:

pkgxx/class.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/class.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/class.moon'

pkgxx/context.moon:

pkgxx/context.moon.install: pkgxx/context.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/context.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx'
	$(Q)install -m0755 pkgxx/context.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/context.moon

pkgxx/context.moon.clean:

pkgxx/context.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/context.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/context.moon'

pkgxx/fs.moon:

pkgxx/fs.moon.install: pkgxx/fs.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/fs.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx'
	$(Q)install -m0755 pkgxx/fs.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/fs.moon

pkgxx/fs.moon.clean:

pkgxx/fs.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/fs.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/fs.moon'

pkgxx/macro.moon:

pkgxx/macro.moon.install: pkgxx/macro.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/macro.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx'
	$(Q)install -m0755 pkgxx/macro.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/macro.moon

pkgxx/macro.moon.clean:

pkgxx/macro.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/macro.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/macro.moon'

pkgxx/module.moon:

pkgxx/module.moon.install: pkgxx/module.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/module.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx'
	$(Q)install -m0755 pkgxx/module.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/module.moon

pkgxx/module.moon.clean:

pkgxx/module.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/module.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/module.moon'

pkgxx/package.moon:

pkgxx/package.moon.install: pkgxx/package.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/package.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx'
	$(Q)install -m0755 pkgxx/package.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/package.moon

pkgxx/package.moon.clean:

pkgxx/package.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/package.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/package.moon'

pkgxx/recipe.moon:

pkgxx/recipe.moon.install: pkgxx/recipe.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/recipe.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx'
	$(Q)install -m0755 pkgxx/recipe.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/recipe.moon

pkgxx/recipe.moon.clean:

pkgxx/recipe.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/recipe.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/recipe.moon'

pkgxx/source.moon:

pkgxx/source.moon.install: pkgxx/source.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/source.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx'
	$(Q)install -m0755 pkgxx/source.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/source.moon

pkgxx/source.moon.clean:

pkgxx/source.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/source.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/source.moon'

pkgxx/ui.moon:

pkgxx/ui.moon.install: pkgxx/ui.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/ui.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx'
	$(Q)install -m0755 pkgxx/ui.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/ui.moon

pkgxx/ui.moon.clean:

pkgxx/ui.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/ui.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/ui.moon'

pkgxx.moon:

pkgxx.moon.install: pkgxx.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)'
	$(Q)install -m0755 pkgxx.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx.moon

pkgxx.moon.clean:

pkgxx.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx.moon'

modules/apk.moon:

modules/apk.moon.install: modules/apk.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/apk.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/apk.moon $(DESTDIR)$(SHAREDIR)/pkgxx/apk.moon

modules/apk.moon.clean:

modules/apk.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/apk.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/apk.moon'

modules/apt.moon:

modules/apt.moon.install: modules/apt.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/apt.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/apt.moon $(DESTDIR)$(SHAREDIR)/pkgxx/apt.moon

modules/apt.moon.clean:

modules/apt.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/apt.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/apt.moon'

modules/autotools.moon:

modules/autotools.moon.install: modules/autotools.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/autotools.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/autotools.moon $(DESTDIR)$(SHAREDIR)/pkgxx/autotools.moon

modules/autotools.moon.clean:

modules/autotools.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/autotools.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/autotools.moon'

modules/build.zsh.moon:

modules/build.zsh.moon.install: modules/build.zsh.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/build.zsh.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/build.zsh.moon $(DESTDIR)$(SHAREDIR)/pkgxx/build.zsh.moon

modules/build.zsh.moon.clean:

modules/build.zsh.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/build.zsh.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/build.zsh.moon'

modules/cmake.moon:

modules/cmake.moon.install: modules/cmake.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/cmake.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/cmake.moon $(DESTDIR)$(SHAREDIR)/pkgxx/cmake.moon

modules/cmake.moon.clean:

modules/cmake.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/cmake.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/cmake.moon'

modules/createrepo.moon:

modules/createrepo.moon.install: modules/createrepo.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/createrepo.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/createrepo.moon $(DESTDIR)$(SHAREDIR)/pkgxx/createrepo.moon

modules/createrepo.moon.clean:

modules/createrepo.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/createrepo.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/createrepo.moon'

modules/debian.moon:

modules/debian.moon.install: modules/debian.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/debian.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/debian.moon $(DESTDIR)$(SHAREDIR)/pkgxx/debian.moon

modules/debian.moon.clean:

modules/debian.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/debian.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/debian.moon'

modules/dnf.moon:

modules/dnf.moon.install: modules/dnf.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/dnf.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/dnf.moon $(DESTDIR)$(SHAREDIR)/pkgxx/dnf.moon

modules/dnf.moon.clean:

modules/dnf.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/dnf.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/dnf.moon'

modules/dpkg.moon:

modules/dpkg.moon.install: modules/dpkg.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/dpkg.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/dpkg.moon $(DESTDIR)$(SHAREDIR)/pkgxx/dpkg.moon

modules/dpkg.moon.clean:

modules/dpkg.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/dpkg.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/dpkg.moon'

modules/fedora.moon:

modules/fedora.moon.install: modules/fedora.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/fedora.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/fedora.moon $(DESTDIR)$(SHAREDIR)/pkgxx/fedora.moon

modules/fedora.moon.clean:

modules/fedora.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/fedora.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/fedora.moon'

modules/ftp.moon:

modules/ftp.moon.install: modules/ftp.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/ftp.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/ftp.moon $(DESTDIR)$(SHAREDIR)/pkgxx/ftp.moon

modules/ftp.moon.clean:

modules/ftp.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/ftp.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/ftp.moon'

modules/github.moon:

modules/github.moon.install: modules/github.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/github.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/github.moon $(DESTDIR)$(SHAREDIR)/pkgxx/github.moon

modules/github.moon.clean:

modules/github.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/github.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/github.moon'

modules/git.moon:

modules/git.moon.install: modules/git.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/git.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/git.moon $(DESTDIR)$(SHAREDIR)/pkgxx/git.moon

modules/git.moon.clean:

modules/git.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/git.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/git.moon'

modules/http.moon:

modules/http.moon.install: modules/http.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/http.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/http.moon $(DESTDIR)$(SHAREDIR)/pkgxx/http.moon

modules/http.moon.clean:

modules/http.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/http.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/http.moon'

modules/https.moon:

modules/https.moon.install: modules/https.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/https.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/https.moon $(DESTDIR)$(SHAREDIR)/pkgxx/https.moon

modules/https.moon.clean:

modules/https.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/https.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/https.moon'

modules/make.moon:

modules/make.moon.install: modules/make.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/make.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/make.moon $(DESTDIR)$(SHAREDIR)/pkgxx/make.moon

modules/make.moon.clean:

modules/make.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/make.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/make.moon'

modules/man.moon:

modules/man.moon.install: modules/man.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/man.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/man.moon $(DESTDIR)$(SHAREDIR)/pkgxx/man.moon

modules/man.moon.clean:

modules/man.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/man.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/man.moon'

modules/ownership.moon:

modules/ownership.moon.install: modules/ownership.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/ownership.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/ownership.moon $(DESTDIR)$(SHAREDIR)/pkgxx/ownership.moon

modules/ownership.moon.clean:

modules/ownership.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/ownership.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/ownership.moon'

modules/pacman.moon:

modules/pacman.moon.install: modules/pacman.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/pacman.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/pacman.moon $(DESTDIR)$(SHAREDIR)/pkgxx/pacman.moon

modules/pacman.moon.clean:

modules/pacman.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/pacman.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/pacman.moon'

modules/perl.moon:

modules/perl.moon.install: modules/perl.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/perl.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/perl.moon $(DESTDIR)$(SHAREDIR)/pkgxx/perl.moon

modules/perl.moon.clean:

modules/perl.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/perl.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/perl.moon'

modules/pkgutils.moon:

modules/pkgutils.moon.install: modules/pkgutils.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/pkgutils.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/pkgutils.moon $(DESTDIR)$(SHAREDIR)/pkgxx/pkgutils.moon

modules/pkgutils.moon.clean:

modules/pkgutils.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/pkgutils.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/pkgutils.moon'

modules/reprepro.moon:

modules/reprepro.moon.install: modules/reprepro.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/reprepro.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/reprepro.moon $(DESTDIR)$(SHAREDIR)/pkgxx/reprepro.moon

modules/reprepro.moon.clean:

modules/reprepro.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/reprepro.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/reprepro.moon'

modules/rpm.moon:

modules/rpm.moon.install: modules/rpm.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/rpm.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/rpm.moon $(DESTDIR)$(SHAREDIR)/pkgxx/rpm.moon

modules/rpm.moon.clean:

modules/rpm.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/rpm.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/rpm.moon'

modules/strip.moon:

modules/strip.moon.install: modules/strip.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/strip.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/strip.moon $(DESTDIR)$(SHAREDIR)/pkgxx/strip.moon

modules/strip.moon.clean:

modules/strip.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/strip.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/strip.moon'

modules/ubuntu.moon:

modules/ubuntu.moon.install: modules/ubuntu.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/ubuntu.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/ubuntu.moon $(DESTDIR)$(SHAREDIR)/pkgxx/ubuntu.moon

modules/ubuntu.moon.clean:

modules/ubuntu.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/ubuntu.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/ubuntu.moon'

modules/vim.moon:

modules/vim.moon.install: modules/vim.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/vim.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/vim.moon $(DESTDIR)$(SHAREDIR)/pkgxx/vim.moon

modules/vim.moon.clean:

modules/vim.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/vim.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/vim.moon'

modules/waf.moon:

modules/waf.moon.install: modules/waf.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/pkgxx/waf.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/waf.moon $(DESTDIR)$(SHAREDIR)/pkgxx/waf.moon

modules/waf.moon.clean:

modules/waf.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/pkgxx/waf.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/waf.moon'

main: main.moon
	@echo '[01;32m  SED >   [01;37mmain[00m'
	$(Q)sed -e 's&@LIBDIR@&$(LIBDIR)&;s&@BINDIR@&$(BINDIR)&;s&@SHAREDIR@&$(SHAREDIR)&;' main.moon > 'main'
	$(Q)chmod +x 'main'


main.install: main
	@echo '[01;31m  IN >    [01;37m$(BINDIR)/pkgxx[00m'
	$(Q)mkdir -p '$(DESTDIR)$(BINDIR)'
	$(Q)install -m0755 main $(DESTDIR)$(BINDIR)/pkgxx

main.clean:
	@echo '[01;37m  RM >    [01;37mmain[00m'
	$(Q)rm -f main

main.uninstall:
	@echo '[01;37m  RM >    [01;37m$(BINDIR)/pkgxx[00m'
	$(Q)rm -f '$(DESTDIR)$(BINDIR)/pkgxx'

$(DESTDIR)$(PREFIX):
	@echo '[01;35m  DIR >   [01;37m$(PREFIX)[00m'
	$(Q)mkdir -p $(DESTDIR)$(PREFIX)
$(DESTDIR)$(BINDIR):
	@echo '[01;35m  DIR >   [01;37m$(BINDIR)[00m'
	$(Q)mkdir -p $(DESTDIR)$(BINDIR)
$(DESTDIR)$(LIBDIR):
	@echo '[01;35m  DIR >   [01;37m$(LIBDIR)[00m'
	$(Q)mkdir -p $(DESTDIR)$(LIBDIR)
$(DESTDIR)$(SHAREDIR):
	@echo '[01;35m  DIR >   [01;37m$(SHAREDIR)[00m'
	$(Q)mkdir -p $(DESTDIR)$(SHAREDIR)
$(DESTDIR)$(INCLUDEDIR):
	@echo '[01;35m  DIR >   [01;37m$(INCLUDEDIR)[00m'
	$(Q)mkdir -p $(DESTDIR)$(INCLUDEDIR)
install: subdirs.install pkgxx/atom.moon.install pkgxx/builder.moon.install pkgxx/class.moon.install pkgxx/context.moon.install pkgxx/fs.moon.install pkgxx/macro.moon.install pkgxx/module.moon.install pkgxx/package.moon.install pkgxx/recipe.moon.install pkgxx/source.moon.install pkgxx/ui.moon.install pkgxx.moon.install modules/apk.moon.install modules/apt.moon.install modules/autotools.moon.install modules/build.zsh.moon.install modules/cmake.moon.install modules/createrepo.moon.install modules/debian.moon.install modules/dnf.moon.install modules/dpkg.moon.install modules/fedora.moon.install modules/ftp.moon.install modules/github.moon.install modules/git.moon.install modules/http.moon.install modules/https.moon.install modules/make.moon.install modules/man.moon.install modules/ownership.moon.install modules/pacman.moon.install modules/perl.moon.install modules/pkgutils.moon.install modules/reprepro.moon.install modules/rpm.moon.install modules/strip.moon.install modules/ubuntu.moon.install modules/vim.moon.install modules/waf.moon.install main.install
	@:

subdirs.install:

uninstall: subdirs.uninstall pkgxx/atom.moon.uninstall pkgxx/builder.moon.uninstall pkgxx/class.moon.uninstall pkgxx/context.moon.uninstall pkgxx/fs.moon.uninstall pkgxx/macro.moon.uninstall pkgxx/module.moon.uninstall pkgxx/package.moon.uninstall pkgxx/recipe.moon.uninstall pkgxx/source.moon.uninstall pkgxx/ui.moon.uninstall pkgxx.moon.uninstall modules/apk.moon.uninstall modules/apt.moon.uninstall modules/autotools.moon.uninstall modules/build.zsh.moon.uninstall modules/cmake.moon.uninstall modules/createrepo.moon.uninstall modules/debian.moon.uninstall modules/dnf.moon.uninstall modules/dpkg.moon.uninstall modules/fedora.moon.uninstall modules/ftp.moon.uninstall modules/github.moon.uninstall modules/git.moon.uninstall modules/http.moon.uninstall modules/https.moon.uninstall modules/make.moon.uninstall modules/man.moon.uninstall modules/ownership.moon.uninstall modules/pacman.moon.uninstall modules/perl.moon.uninstall modules/pkgutils.moon.uninstall modules/reprepro.moon.uninstall modules/rpm.moon.uninstall modules/strip.moon.uninstall modules/ubuntu.moon.uninstall modules/vim.moon.uninstall modules/waf.moon.uninstall main.uninstall
	@:

subdirs.uninstall:

test: all subdirs subdirs.test
	@:

subdirs.test:

clean: pkgxx/atom.moon.clean pkgxx/builder.moon.clean pkgxx/class.moon.clean pkgxx/context.moon.clean pkgxx/fs.moon.clean pkgxx/macro.moon.clean pkgxx/module.moon.clean pkgxx/package.moon.clean pkgxx/recipe.moon.clean pkgxx/source.moon.clean pkgxx/ui.moon.clean pkgxx.moon.clean modules/apk.moon.clean modules/apt.moon.clean modules/autotools.moon.clean modules/build.zsh.moon.clean modules/cmake.moon.clean modules/createrepo.moon.clean modules/debian.moon.clean modules/dnf.moon.clean modules/dpkg.moon.clean modules/fedora.moon.clean modules/ftp.moon.clean modules/github.moon.clean modules/git.moon.clean modules/http.moon.clean modules/https.moon.clean modules/make.moon.clean modules/man.moon.clean modules/ownership.moon.clean modules/pacman.moon.clean modules/perl.moon.clean modules/pkgutils.moon.clean modules/reprepro.moon.clean modules/rpm.moon.clean modules/strip.moon.clean modules/ubuntu.moon.clean modules/vim.moon.clean modules/waf.moon.clean main.clean

distclean: clean

dist: dist-gz dist-xz dist-bz2
	$(Q)rm -- $(PACKAGE)-$(VERSION)

distdir:
	$(Q)rm -rf -- $(PACKAGE)-$(VERSION)
	$(Q)ln -s -- . $(PACKAGE)-$(VERSION)

dist-gz: $(PACKAGE)-$(VERSION).tar.gz
$(PACKAGE)-$(VERSION).tar.gz: distdir
	@echo '[01;33m  TAR >   [01;37m$(PACKAGE)-$(VERSION).tar.gz[00m'
	$(Q)tar czf $(PACKAGE)-$(VERSION).tar.gz \
		$(PACKAGE)-$(VERSION)/lint_config.moon \
		$(PACKAGE)-$(VERSION)/modules/apk.moon \
		$(PACKAGE)-$(VERSION)/modules/apt.moon \
		$(PACKAGE)-$(VERSION)/modules/autotools.moon \
		$(PACKAGE)-$(VERSION)/modules/build.zsh.moon \
		$(PACKAGE)-$(VERSION)/modules/cmake.moon \
		$(PACKAGE)-$(VERSION)/modules/createrepo.moon \
		$(PACKAGE)-$(VERSION)/modules/debian.moon \
		$(PACKAGE)-$(VERSION)/modules/dnf.moon \
		$(PACKAGE)-$(VERSION)/modules/dpkg.moon \
		$(PACKAGE)-$(VERSION)/modules/fedora.moon \
		$(PACKAGE)-$(VERSION)/modules/ftp.moon \
		$(PACKAGE)-$(VERSION)/modules/github.moon \
		$(PACKAGE)-$(VERSION)/modules/git.moon \
		$(PACKAGE)-$(VERSION)/modules/http.moon \
		$(PACKAGE)-$(VERSION)/modules/https.moon \
		$(PACKAGE)-$(VERSION)/modules/make.moon \
		$(PACKAGE)-$(VERSION)/modules/man.moon \
		$(PACKAGE)-$(VERSION)/modules/ownership.moon \
		$(PACKAGE)-$(VERSION)/modules/pacman.moon \
		$(PACKAGE)-$(VERSION)/modules/perl.moon \
		$(PACKAGE)-$(VERSION)/modules/pkgutils.moon \
		$(PACKAGE)-$(VERSION)/modules/reprepro.moon \
		$(PACKAGE)-$(VERSION)/modules/rpm.moon \
		$(PACKAGE)-$(VERSION)/modules/strip.moon \
		$(PACKAGE)-$(VERSION)/modules/ubuntu.moon \
		$(PACKAGE)-$(VERSION)/modules/vim.moon \
		$(PACKAGE)-$(VERSION)/modules/waf.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/atom.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/builder.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/class.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/context.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/fs.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/macro.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/module.moon \
		$(PACKAGE)-$(VERSION)/pkgxx.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/package.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/recipe.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/source.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/ui.moon \
		$(PACKAGE)-$(VERSION)/tests/atom.moon \
		$(PACKAGE)-$(VERSION)/tests/macro.moon \
		$(PACKAGE)-$(VERSION)/tests/modules.moon \
		$(PACKAGE)-$(VERSION)/tests/recipe.moon \
		$(PACKAGE)-$(VERSION)/tests/sources.moon \
		$(PACKAGE)-$(VERSION)/project.zsh \
		$(PACKAGE)-$(VERSION)/Makefile \
		$(PACKAGE)-$(VERSION)/config.ld \
		$(PACKAGE)-$(VERSION)/doc/css/ldoc.css \
		$(PACKAGE)-$(VERSION)/doc/css/ldoc.ltp \
		$(PACKAGE)-$(VERSION)/doc/examples/api_basics.moon \
		$(PACKAGE)-$(VERSION)/README.md \
		$(PACKAGE)-$(VERSION)/main.moon

dist-xz: $(PACKAGE)-$(VERSION).tar.xz
$(PACKAGE)-$(VERSION).tar.xz: distdir
	@echo '[01;33m  TAR >   [01;37m$(PACKAGE)-$(VERSION).tar.xz[00m'
	$(Q)tar cJf $(PACKAGE)-$(VERSION).tar.xz \
		$(PACKAGE)-$(VERSION)/lint_config.moon \
		$(PACKAGE)-$(VERSION)/modules/apk.moon \
		$(PACKAGE)-$(VERSION)/modules/apt.moon \
		$(PACKAGE)-$(VERSION)/modules/autotools.moon \
		$(PACKAGE)-$(VERSION)/modules/build.zsh.moon \
		$(PACKAGE)-$(VERSION)/modules/cmake.moon \
		$(PACKAGE)-$(VERSION)/modules/createrepo.moon \
		$(PACKAGE)-$(VERSION)/modules/debian.moon \
		$(PACKAGE)-$(VERSION)/modules/dnf.moon \
		$(PACKAGE)-$(VERSION)/modules/dpkg.moon \
		$(PACKAGE)-$(VERSION)/modules/fedora.moon \
		$(PACKAGE)-$(VERSION)/modules/ftp.moon \
		$(PACKAGE)-$(VERSION)/modules/github.moon \
		$(PACKAGE)-$(VERSION)/modules/git.moon \
		$(PACKAGE)-$(VERSION)/modules/http.moon \
		$(PACKAGE)-$(VERSION)/modules/https.moon \
		$(PACKAGE)-$(VERSION)/modules/make.moon \
		$(PACKAGE)-$(VERSION)/modules/man.moon \
		$(PACKAGE)-$(VERSION)/modules/ownership.moon \
		$(PACKAGE)-$(VERSION)/modules/pacman.moon \
		$(PACKAGE)-$(VERSION)/modules/perl.moon \
		$(PACKAGE)-$(VERSION)/modules/pkgutils.moon \
		$(PACKAGE)-$(VERSION)/modules/reprepro.moon \
		$(PACKAGE)-$(VERSION)/modules/rpm.moon \
		$(PACKAGE)-$(VERSION)/modules/strip.moon \
		$(PACKAGE)-$(VERSION)/modules/ubuntu.moon \
		$(PACKAGE)-$(VERSION)/modules/vim.moon \
		$(PACKAGE)-$(VERSION)/modules/waf.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/atom.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/builder.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/class.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/context.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/fs.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/macro.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/module.moon \
		$(PACKAGE)-$(VERSION)/pkgxx.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/package.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/recipe.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/source.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/ui.moon \
		$(PACKAGE)-$(VERSION)/tests/atom.moon \
		$(PACKAGE)-$(VERSION)/tests/macro.moon \
		$(PACKAGE)-$(VERSION)/tests/modules.moon \
		$(PACKAGE)-$(VERSION)/tests/recipe.moon \
		$(PACKAGE)-$(VERSION)/tests/sources.moon \
		$(PACKAGE)-$(VERSION)/project.zsh \
		$(PACKAGE)-$(VERSION)/Makefile \
		$(PACKAGE)-$(VERSION)/config.ld \
		$(PACKAGE)-$(VERSION)/doc/css/ldoc.css \
		$(PACKAGE)-$(VERSION)/doc/css/ldoc.ltp \
		$(PACKAGE)-$(VERSION)/doc/examples/api_basics.moon \
		$(PACKAGE)-$(VERSION)/README.md \
		$(PACKAGE)-$(VERSION)/main.moon

dist-bz2: $(PACKAGE)-$(VERSION).tar.bz2
$(PACKAGE)-$(VERSION).tar.bz2: distdir
	@echo '[01;33m  TAR >   [01;37m$(PACKAGE)-$(VERSION).tar.bz2[00m'
	$(Q)tar cjf $(PACKAGE)-$(VERSION).tar.bz2 \
		$(PACKAGE)-$(VERSION)/lint_config.moon \
		$(PACKAGE)-$(VERSION)/modules/apk.moon \
		$(PACKAGE)-$(VERSION)/modules/apt.moon \
		$(PACKAGE)-$(VERSION)/modules/autotools.moon \
		$(PACKAGE)-$(VERSION)/modules/build.zsh.moon \
		$(PACKAGE)-$(VERSION)/modules/cmake.moon \
		$(PACKAGE)-$(VERSION)/modules/createrepo.moon \
		$(PACKAGE)-$(VERSION)/modules/debian.moon \
		$(PACKAGE)-$(VERSION)/modules/dnf.moon \
		$(PACKAGE)-$(VERSION)/modules/dpkg.moon \
		$(PACKAGE)-$(VERSION)/modules/fedora.moon \
		$(PACKAGE)-$(VERSION)/modules/ftp.moon \
		$(PACKAGE)-$(VERSION)/modules/github.moon \
		$(PACKAGE)-$(VERSION)/modules/git.moon \
		$(PACKAGE)-$(VERSION)/modules/http.moon \
		$(PACKAGE)-$(VERSION)/modules/https.moon \
		$(PACKAGE)-$(VERSION)/modules/make.moon \
		$(PACKAGE)-$(VERSION)/modules/man.moon \
		$(PACKAGE)-$(VERSION)/modules/ownership.moon \
		$(PACKAGE)-$(VERSION)/modules/pacman.moon \
		$(PACKAGE)-$(VERSION)/modules/perl.moon \
		$(PACKAGE)-$(VERSION)/modules/pkgutils.moon \
		$(PACKAGE)-$(VERSION)/modules/reprepro.moon \
		$(PACKAGE)-$(VERSION)/modules/rpm.moon \
		$(PACKAGE)-$(VERSION)/modules/strip.moon \
		$(PACKAGE)-$(VERSION)/modules/ubuntu.moon \
		$(PACKAGE)-$(VERSION)/modules/vim.moon \
		$(PACKAGE)-$(VERSION)/modules/waf.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/atom.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/builder.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/class.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/context.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/fs.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/macro.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/module.moon \
		$(PACKAGE)-$(VERSION)/pkgxx.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/package.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/recipe.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/source.moon \
		$(PACKAGE)-$(VERSION)/pkgxx/ui.moon \
		$(PACKAGE)-$(VERSION)/tests/atom.moon \
		$(PACKAGE)-$(VERSION)/tests/macro.moon \
		$(PACKAGE)-$(VERSION)/tests/modules.moon \
		$(PACKAGE)-$(VERSION)/tests/recipe.moon \
		$(PACKAGE)-$(VERSION)/tests/sources.moon \
		$(PACKAGE)-$(VERSION)/project.zsh \
		$(PACKAGE)-$(VERSION)/Makefile \
		$(PACKAGE)-$(VERSION)/config.ld \
		$(PACKAGE)-$(VERSION)/doc/css/ldoc.css \
		$(PACKAGE)-$(VERSION)/doc/css/ldoc.ltp \
		$(PACKAGE)-$(VERSION)/doc/examples/api_basics.moon \
		$(PACKAGE)-$(VERSION)/README.md \
		$(PACKAGE)-$(VERSION)/main.moon

help:
	@echo '[01;37m :: pkgxx-0.2.0[00m'
	@echo ''
	@echo '[01;37mGeneric targets:[00m'
	@echo '[00m    - [01;32mhelp          [37m Prints this help message.[00m'
	@echo '[00m    - [01;32mall           [37m Builds all targets.[00m'
	@echo '[00m    - [01;32mdist          [37m Creates tarballs of the files of the project.[00m'
	@echo '[00m    - [01;32minstall       [37m Installs the project.[00m'
	@echo '[00m    - [01;32mclean         [37m Removes compiled files.[00m'
	@echo '[00m    - [01;32muninstall     [37m Deinstalls the project.[00m'
	@echo ''
	@echo '[01;37mCLI-modifiable variables:[00m'
	@echo '    - [01;34mCC            [37m ${CC}[00m'
	@echo '    - [01;34mCFLAGS        [37m ${CFLAGS}[00m'
	@echo '    - [01;34mLDFLAGS       [37m ${LDFLAGS}[00m'
	@echo '    - [01;34mDESTDIR       [37m ${DESTDIR}[00m'
	@echo '    - [01;34mPREFIX        [37m ${PREFIX}[00m'
	@echo '    - [01;34mBINDIR        [37m ${BINDIR}[00m'
	@echo '    - [01;34mLIBDIR        [37m ${LIBDIR}[00m'
	@echo '    - [01;34mSHAREDIR      [37m ${SHAREDIR}[00m'
	@echo '    - [01;34mINCLUDEDIR    [37m ${INCLUDEDIR}[00m'
	@echo '    - [01;34mLUA_VERSION   [37m ${LUA_VERSION}[00m'
	@echo ''
	@echo '[01;37mProject targets: [00m'
	@echo '    - [01;33mmain          [37m script[00m'
	@echo ''
	@echo '[01;37mMakefile options:[00m'
	@echo '    - gnu:           false'
	@echo '    - colors:        true'
	@echo ''
	@echo '[01;37mRebuild the Makefile with:[00m'
	@echo '    zsh ./build.zsh -c'
.PHONY: all subdirs clean distclean dist install uninstall help

