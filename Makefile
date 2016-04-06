PACKAGE = 'pkgxx'
VERSION = '0.0.1'

PREFIX := /usr/local
BINDIR := $(PREFIX)/bin
LIBDIR := $(PREFIX)/lib
SHAREDIR := $(PREFIX)/share
INCLUDEDIR := $(PREFIX)/include
LUA_VERSION := 5.2

CC := cc
AR := ar
RANLIB := ranlib
CFLAGS := 
LDFLAGS := 

Q := @

all: main.lua main.in pkgxx/context.lua pkgxx/fs.lua pkgxx/macro.lua pkgxx/recipe.lua pkgxx/sources.lua pkgxx/ui.lua pkgxx.lua modules/apk.lua modules/autotools.lua modules/cmake.lua modules/debian.lua modules/dnf.lua modules/dpkg.lua modules/fedora.lua modules/ftp.lua modules/git.lua modules/http.lua modules/https.lua modules/make.lua modules/pacman.lua modules/pkgutils.lua modules/reprepro.lua modules/rpm.lua modules/waf.lua
	@:

main.lua:

main.lua.install: main.lua
	@echo '[01;31m  [IN]    [01;37m$(BINDIR)/pkgxx[00m'
	$(Q)mkdir -p '$(DESTDIR)$(BINDIR)'
	$(Q)install -m0755 main.lua $(DESTDIR)$(BINDIR)/pkgxx

main.lua.clean:

main.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(BINDIR)/pkgxx[00m'
	$(Q)rm -f '$(DESTDIR)$(BINDIR)/pkgxx'

main.in: main.moon
	@echo '[01;33m  [MOON]  [01;37mmain.in[00m'
	$(Q)moonc -p main.moon > 'main.in'


main.in.install: main.in
	@echo '[01;31m  [IN]    [01;37m$(BINDIR)/main.in[00m'
	$(Q)mkdir -p '$(DESTDIR)$(BINDIR)'
	$(Q)install -m0755 main.in $(DESTDIR)$(BINDIR)/main.in

main.in.clean:
	@echo '[01;37m  [RM]    [01;37mmain.in[00m'
	$(Q)rm -f main.in

main.in.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(BINDIR)/main.in[00m'
	$(Q)rm -f '$(DESTDIR)$(BINDIR)/main.in'

pkgxx/context.lua: pkgxx/context.moon
	@echo '[01;33m  [MOON]  [01;37mpkgxx/context.lua[00m'
	$(Q)moonc -p pkgxx/context.moon > 'pkgxx/context.lua'


pkgxx/context.lua.install: pkgxx/context.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/context.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx'
	$(Q)install -m0755 pkgxx/context.lua $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/context.lua

pkgxx/context.lua.clean:
	@echo '[01;37m  [RM]    [01;37mpkgxx/context.lua[00m'
	$(Q)rm -f pkgxx/context.lua

pkgxx/context.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/context.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/context.lua'

pkgxx/fs.lua: pkgxx/fs.moon
	@echo '[01;33m  [MOON]  [01;37mpkgxx/fs.lua[00m'
	$(Q)moonc -p pkgxx/fs.moon > 'pkgxx/fs.lua'


pkgxx/fs.lua.install: pkgxx/fs.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/fs.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx'
	$(Q)install -m0755 pkgxx/fs.lua $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/fs.lua

pkgxx/fs.lua.clean:
	@echo '[01;37m  [RM]    [01;37mpkgxx/fs.lua[00m'
	$(Q)rm -f pkgxx/fs.lua

pkgxx/fs.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/fs.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/fs.lua'

pkgxx/macro.lua: pkgxx/macro.moon
	@echo '[01;33m  [MOON]  [01;37mpkgxx/macro.lua[00m'
	$(Q)moonc -p pkgxx/macro.moon > 'pkgxx/macro.lua'


pkgxx/macro.lua.install: pkgxx/macro.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/macro.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx'
	$(Q)install -m0755 pkgxx/macro.lua $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/macro.lua

pkgxx/macro.lua.clean:
	@echo '[01;37m  [RM]    [01;37mpkgxx/macro.lua[00m'
	$(Q)rm -f pkgxx/macro.lua

pkgxx/macro.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/macro.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/macro.lua'

pkgxx/recipe.lua: pkgxx/recipe.moon
	@echo '[01;33m  [MOON]  [01;37mpkgxx/recipe.lua[00m'
	$(Q)moonc -p pkgxx/recipe.moon > 'pkgxx/recipe.lua'


pkgxx/recipe.lua.install: pkgxx/recipe.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/recipe.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx'
	$(Q)install -m0755 pkgxx/recipe.lua $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/recipe.lua

pkgxx/recipe.lua.clean:
	@echo '[01;37m  [RM]    [01;37mpkgxx/recipe.lua[00m'
	$(Q)rm -f pkgxx/recipe.lua

pkgxx/recipe.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/recipe.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/recipe.lua'

pkgxx/sources.lua: pkgxx/sources.moon
	@echo '[01;33m  [MOON]  [01;37mpkgxx/sources.lua[00m'
	$(Q)moonc -p pkgxx/sources.moon > 'pkgxx/sources.lua'


pkgxx/sources.lua.install: pkgxx/sources.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/sources.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx'
	$(Q)install -m0755 pkgxx/sources.lua $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/sources.lua

pkgxx/sources.lua.clean:
	@echo '[01;37m  [RM]    [01;37mpkgxx/sources.lua[00m'
	$(Q)rm -f pkgxx/sources.lua

pkgxx/sources.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/sources.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/sources.lua'

pkgxx/ui.lua: pkgxx/ui.moon
	@echo '[01;33m  [MOON]  [01;37mpkgxx/ui.lua[00m'
	$(Q)moonc -p pkgxx/ui.moon > 'pkgxx/ui.lua'


pkgxx/ui.lua.install: pkgxx/ui.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/ui.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx'
	$(Q)install -m0755 pkgxx/ui.lua $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/ui.lua

pkgxx/ui.lua.clean:
	@echo '[01;37m  [RM]    [01;37mpkgxx/ui.lua[00m'
	$(Q)rm -f pkgxx/ui.lua

pkgxx/ui.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/ui.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/ui.lua'

pkgxx.lua: pkgxx.moon
	@echo '[01;33m  [MOON]  [01;37mpkgxx.lua[00m'
	$(Q)moonc -p pkgxx.moon > 'pkgxx.lua'


pkgxx.lua.install: pkgxx.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/pkgxx.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx'
	$(Q)install -m0755 pkgxx.lua $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/pkgxx.lua

pkgxx.lua.clean:
	@echo '[01;37m  [RM]    [01;37mpkgxx.lua[00m'
	$(Q)rm -f pkgxx.lua

pkgxx.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/pkgxx.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx/pkgxx.lua'

modules/apk.lua: modules/apk.moon
	@echo '[01;33m  [MOON]  [01;37mmodules/apk.lua[00m'
	$(Q)moonc -p modules/apk.moon > 'modules/apk.lua'


modules/apk.lua.install: modules/apk.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/pkgxx/apk.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/apk.lua $(DESTDIR)$(SHAREDIR)/pkgxx/apk.lua

modules/apk.lua.clean:
	@echo '[01;37m  [RM]    [01;37mmodules/apk.lua[00m'
	$(Q)rm -f modules/apk.lua

modules/apk.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/pkgxx/apk.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/apk.lua'

modules/autotools.lua: modules/autotools.moon
	@echo '[01;33m  [MOON]  [01;37mmodules/autotools.lua[00m'
	$(Q)moonc -p modules/autotools.moon > 'modules/autotools.lua'


modules/autotools.lua.install: modules/autotools.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/pkgxx/autotools.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/autotools.lua $(DESTDIR)$(SHAREDIR)/pkgxx/autotools.lua

modules/autotools.lua.clean:
	@echo '[01;37m  [RM]    [01;37mmodules/autotools.lua[00m'
	$(Q)rm -f modules/autotools.lua

modules/autotools.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/pkgxx/autotools.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/autotools.lua'

modules/cmake.lua: modules/cmake.moon
	@echo '[01;33m  [MOON]  [01;37mmodules/cmake.lua[00m'
	$(Q)moonc -p modules/cmake.moon > 'modules/cmake.lua'


modules/cmake.lua.install: modules/cmake.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/pkgxx/cmake.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/cmake.lua $(DESTDIR)$(SHAREDIR)/pkgxx/cmake.lua

modules/cmake.lua.clean:
	@echo '[01;37m  [RM]    [01;37mmodules/cmake.lua[00m'
	$(Q)rm -f modules/cmake.lua

modules/cmake.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/pkgxx/cmake.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/cmake.lua'

modules/debian.lua: modules/debian.moon
	@echo '[01;33m  [MOON]  [01;37mmodules/debian.lua[00m'
	$(Q)moonc -p modules/debian.moon > 'modules/debian.lua'


modules/debian.lua.install: modules/debian.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/pkgxx/debian.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/debian.lua $(DESTDIR)$(SHAREDIR)/pkgxx/debian.lua

modules/debian.lua.clean:
	@echo '[01;37m  [RM]    [01;37mmodules/debian.lua[00m'
	$(Q)rm -f modules/debian.lua

modules/debian.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/pkgxx/debian.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/debian.lua'

modules/dnf.lua: modules/dnf.moon
	@echo '[01;33m  [MOON]  [01;37mmodules/dnf.lua[00m'
	$(Q)moonc -p modules/dnf.moon > 'modules/dnf.lua'


modules/dnf.lua.install: modules/dnf.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/pkgxx/dnf.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/dnf.lua $(DESTDIR)$(SHAREDIR)/pkgxx/dnf.lua

modules/dnf.lua.clean:
	@echo '[01;37m  [RM]    [01;37mmodules/dnf.lua[00m'
	$(Q)rm -f modules/dnf.lua

modules/dnf.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/pkgxx/dnf.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/dnf.lua'

modules/dpkg.lua: modules/dpkg.moon
	@echo '[01;33m  [MOON]  [01;37mmodules/dpkg.lua[00m'
	$(Q)moonc -p modules/dpkg.moon > 'modules/dpkg.lua'


modules/dpkg.lua.install: modules/dpkg.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/pkgxx/dpkg.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/dpkg.lua $(DESTDIR)$(SHAREDIR)/pkgxx/dpkg.lua

modules/dpkg.lua.clean:
	@echo '[01;37m  [RM]    [01;37mmodules/dpkg.lua[00m'
	$(Q)rm -f modules/dpkg.lua

modules/dpkg.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/pkgxx/dpkg.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/dpkg.lua'

modules/fedora.lua: modules/fedora.moon
	@echo '[01;33m  [MOON]  [01;37mmodules/fedora.lua[00m'
	$(Q)moonc -p modules/fedora.moon > 'modules/fedora.lua'


modules/fedora.lua.install: modules/fedora.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/pkgxx/fedora.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/fedora.lua $(DESTDIR)$(SHAREDIR)/pkgxx/fedora.lua

modules/fedora.lua.clean:
	@echo '[01;37m  [RM]    [01;37mmodules/fedora.lua[00m'
	$(Q)rm -f modules/fedora.lua

modules/fedora.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/pkgxx/fedora.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/fedora.lua'

modules/ftp.lua: modules/ftp.moon
	@echo '[01;33m  [MOON]  [01;37mmodules/ftp.lua[00m'
	$(Q)moonc -p modules/ftp.moon > 'modules/ftp.lua'


modules/ftp.lua.install: modules/ftp.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/pkgxx/ftp.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/ftp.lua $(DESTDIR)$(SHAREDIR)/pkgxx/ftp.lua

modules/ftp.lua.clean:
	@echo '[01;37m  [RM]    [01;37mmodules/ftp.lua[00m'
	$(Q)rm -f modules/ftp.lua

modules/ftp.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/pkgxx/ftp.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/ftp.lua'

modules/git.lua: modules/git.moon
	@echo '[01;33m  [MOON]  [01;37mmodules/git.lua[00m'
	$(Q)moonc -p modules/git.moon > 'modules/git.lua'


modules/git.lua.install: modules/git.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/pkgxx/git.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/git.lua $(DESTDIR)$(SHAREDIR)/pkgxx/git.lua

modules/git.lua.clean:
	@echo '[01;37m  [RM]    [01;37mmodules/git.lua[00m'
	$(Q)rm -f modules/git.lua

modules/git.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/pkgxx/git.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/git.lua'

modules/http.lua: modules/http.moon
	@echo '[01;33m  [MOON]  [01;37mmodules/http.lua[00m'
	$(Q)moonc -p modules/http.moon > 'modules/http.lua'


modules/http.lua.install: modules/http.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/pkgxx/http.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/http.lua $(DESTDIR)$(SHAREDIR)/pkgxx/http.lua

modules/http.lua.clean:
	@echo '[01;37m  [RM]    [01;37mmodules/http.lua[00m'
	$(Q)rm -f modules/http.lua

modules/http.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/pkgxx/http.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/http.lua'

modules/https.lua: modules/https.moon
	@echo '[01;33m  [MOON]  [01;37mmodules/https.lua[00m'
	$(Q)moonc -p modules/https.moon > 'modules/https.lua'


modules/https.lua.install: modules/https.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/pkgxx/https.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/https.lua $(DESTDIR)$(SHAREDIR)/pkgxx/https.lua

modules/https.lua.clean:
	@echo '[01;37m  [RM]    [01;37mmodules/https.lua[00m'
	$(Q)rm -f modules/https.lua

modules/https.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/pkgxx/https.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/https.lua'

modules/make.lua: modules/make.moon
	@echo '[01;33m  [MOON]  [01;37mmodules/make.lua[00m'
	$(Q)moonc -p modules/make.moon > 'modules/make.lua'


modules/make.lua.install: modules/make.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/pkgxx/make.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/make.lua $(DESTDIR)$(SHAREDIR)/pkgxx/make.lua

modules/make.lua.clean:
	@echo '[01;37m  [RM]    [01;37mmodules/make.lua[00m'
	$(Q)rm -f modules/make.lua

modules/make.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/pkgxx/make.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/make.lua'

modules/pacman.lua: modules/pacman.moon
	@echo '[01;33m  [MOON]  [01;37mmodules/pacman.lua[00m'
	$(Q)moonc -p modules/pacman.moon > 'modules/pacman.lua'


modules/pacman.lua.install: modules/pacman.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/pkgxx/pacman.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/pacman.lua $(DESTDIR)$(SHAREDIR)/pkgxx/pacman.lua

modules/pacman.lua.clean:
	@echo '[01;37m  [RM]    [01;37mmodules/pacman.lua[00m'
	$(Q)rm -f modules/pacman.lua

modules/pacman.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/pkgxx/pacman.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/pacman.lua'

modules/pkgutils.lua: modules/pkgutils.moon
	@echo '[01;33m  [MOON]  [01;37mmodules/pkgutils.lua[00m'
	$(Q)moonc -p modules/pkgutils.moon > 'modules/pkgutils.lua'


modules/pkgutils.lua.install: modules/pkgutils.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/pkgxx/pkgutils.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/pkgutils.lua $(DESTDIR)$(SHAREDIR)/pkgxx/pkgutils.lua

modules/pkgutils.lua.clean:
	@echo '[01;37m  [RM]    [01;37mmodules/pkgutils.lua[00m'
	$(Q)rm -f modules/pkgutils.lua

modules/pkgutils.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/pkgxx/pkgutils.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/pkgutils.lua'

modules/reprepro.lua: modules/reprepro.moon
	@echo '[01;33m  [MOON]  [01;37mmodules/reprepro.lua[00m'
	$(Q)moonc -p modules/reprepro.moon > 'modules/reprepro.lua'


modules/reprepro.lua.install: modules/reprepro.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/pkgxx/reprepro.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/reprepro.lua $(DESTDIR)$(SHAREDIR)/pkgxx/reprepro.lua

modules/reprepro.lua.clean:
	@echo '[01;37m  [RM]    [01;37mmodules/reprepro.lua[00m'
	$(Q)rm -f modules/reprepro.lua

modules/reprepro.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/pkgxx/reprepro.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/reprepro.lua'

modules/rpm.lua: modules/rpm.moon
	@echo '[01;33m  [MOON]  [01;37mmodules/rpm.lua[00m'
	$(Q)moonc -p modules/rpm.moon > 'modules/rpm.lua'


modules/rpm.lua.install: modules/rpm.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/pkgxx/rpm.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/rpm.lua $(DESTDIR)$(SHAREDIR)/pkgxx/rpm.lua

modules/rpm.lua.clean:
	@echo '[01;37m  [RM]    [01;37mmodules/rpm.lua[00m'
	$(Q)rm -f modules/rpm.lua

modules/rpm.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/pkgxx/rpm.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/rpm.lua'

modules/waf.lua: modules/waf.moon
	@echo '[01;33m  [MOON]  [01;37mmodules/waf.lua[00m'
	$(Q)moonc -p modules/waf.moon > 'modules/waf.lua'


modules/waf.lua.install: modules/waf.lua
	@echo '[01;31m  [IN]    [01;37m$(SHAREDIR)/pkgxx/waf.lua[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/pkgxx'
	$(Q)install -m0755 modules/waf.lua $(DESTDIR)$(SHAREDIR)/pkgxx/waf.lua

modules/waf.lua.clean:
	@echo '[01;37m  [RM]    [01;37mmodules/waf.lua[00m'
	$(Q)rm -f modules/waf.lua

modules/waf.lua.uninstall:
	@echo '[01;37m  [RM]    [01;37m$(SHAREDIR)/pkgxx/waf.lua[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/pkgxx/waf.lua'

$(DESTDIR)$(PREFIX):
	@echo '[01;35m  [DIR]   [01;37m$(PREFIX)[00m'
	$(Q)mkdir -p $(DESTDIR)$(PREFIX)
$(DESTDIR)$(BINDIR):
	@echo '[01;35m  [DIR]   [01;37m$(BINDIR)[00m'
	$(Q)mkdir -p $(DESTDIR)$(BINDIR)
$(DESTDIR)$(LIBDIR):
	@echo '[01;35m  [DIR]   [01;37m$(LIBDIR)[00m'
	$(Q)mkdir -p $(DESTDIR)$(LIBDIR)
$(DESTDIR)$(SHAREDIR):
	@echo '[01;35m  [DIR]   [01;37m$(SHAREDIR)[00m'
	$(Q)mkdir -p $(DESTDIR)$(SHAREDIR)
$(DESTDIR)$(INCLUDEDIR):
	@echo '[01;35m  [DIR]   [01;37m$(INCLUDEDIR)[00m'
	$(Q)mkdir -p $(DESTDIR)$(INCLUDEDIR)
install: subdirs.install main.lua.install main.in.install pkgxx/context.lua.install pkgxx/fs.lua.install pkgxx/macro.lua.install pkgxx/recipe.lua.install pkgxx/sources.lua.install pkgxx/ui.lua.install pkgxx.lua.install modules/apk.lua.install modules/autotools.lua.install modules/cmake.lua.install modules/debian.lua.install modules/dnf.lua.install modules/dpkg.lua.install modules/fedora.lua.install modules/ftp.lua.install modules/git.lua.install modules/http.lua.install modules/https.lua.install modules/make.lua.install modules/pacman.lua.install modules/pkgutils.lua.install modules/reprepro.lua.install modules/rpm.lua.install modules/waf.lua.install
	@:

subdirs.install:

uninstall: subdirs.uninstall main.lua.uninstall main.in.uninstall pkgxx/context.lua.uninstall pkgxx/fs.lua.uninstall pkgxx/macro.lua.uninstall pkgxx/recipe.lua.uninstall pkgxx/sources.lua.uninstall pkgxx/ui.lua.uninstall pkgxx.lua.uninstall modules/apk.lua.uninstall modules/autotools.lua.uninstall modules/cmake.lua.uninstall modules/debian.lua.uninstall modules/dnf.lua.uninstall modules/dpkg.lua.uninstall modules/fedora.lua.uninstall modules/ftp.lua.uninstall modules/git.lua.uninstall modules/http.lua.uninstall modules/https.lua.uninstall modules/make.lua.uninstall modules/pacman.lua.uninstall modules/pkgutils.lua.uninstall modules/reprepro.lua.uninstall modules/rpm.lua.uninstall modules/waf.lua.uninstall
	@:

subdirs.uninstall:

test: all subdirs subdirs.test
	@:

subdirs.test:

clean: main.lua.clean main.in.clean pkgxx/context.lua.clean pkgxx/fs.lua.clean pkgxx/macro.lua.clean pkgxx/recipe.lua.clean pkgxx/sources.lua.clean pkgxx/ui.lua.clean pkgxx.lua.clean modules/apk.lua.clean modules/autotools.lua.clean modules/cmake.lua.clean modules/debian.lua.clean modules/dnf.lua.clean modules/dpkg.lua.clean modules/fedora.lua.clean modules/ftp.lua.clean modules/git.lua.clean modules/http.lua.clean modules/https.lua.clean modules/make.lua.clean modules/pacman.lua.clean modules/pkgutils.lua.clean modules/reprepro.lua.clean modules/rpm.lua.clean modules/waf.lua.clean

distclean: clean

dist: dist-gz dist-xz dist-bz2
	$(Q)rm -- $(PACKAGE)-$(VERSION)

distdir:
	$(Q)rm -rf -- $(PACKAGE)-$(VERSION)
	$(Q)ln -s -- . $(PACKAGE)-$(VERSION)

dist-gz: $(PACKAGE)-$(VERSION).tar.gz
$(PACKAGE)-$(VERSION).tar.gz: distdir
	@echo '[01;33m  [TAR]   [01;37m$(PACKAGE)-$(VERSION).tar.gz[00m'
	$(Q)tar czf $(PACKAGE)-$(VERSION).tar.gz \
		$(PACKAGE)-$(VERSION)/project.zsh \
		$(PACKAGE)-$(VERSION)/Makefile \
		$(PACKAGE)-$(VERSION)/main.moon

dist-xz: $(PACKAGE)-$(VERSION).tar.xz
$(PACKAGE)-$(VERSION).tar.xz: distdir
	@echo '[01;33m  [TAR]   [01;37m$(PACKAGE)-$(VERSION).tar.xz[00m'
	$(Q)tar cJf $(PACKAGE)-$(VERSION).tar.xz \
		$(PACKAGE)-$(VERSION)/project.zsh \
		$(PACKAGE)-$(VERSION)/Makefile \
		$(PACKAGE)-$(VERSION)/main.moon

dist-bz2: $(PACKAGE)-$(VERSION).tar.bz2
$(PACKAGE)-$(VERSION).tar.bz2: distdir
	@echo '[01;33m  [TAR]   [01;37m$(PACKAGE)-$(VERSION).tar.bz2[00m'
	$(Q)tar cjf $(PACKAGE)-$(VERSION).tar.bz2 \
		$(PACKAGE)-$(VERSION)/project.zsh \
		$(PACKAGE)-$(VERSION)/Makefile \
		$(PACKAGE)-$(VERSION)/main.moon

help:
	@echo '[01;37m :: pkgxx-0.0.1[00m'
	@echo ''
	@echo '[01;37mGeneric targets:[00m'
	@echo '[00m    - [01;32mhelp          [37mPrints this help message.[00m'
	@echo '[00m    - [01;32mall           [37mBuilds all targets.[00m'
	@echo '[00m    - [01;32mdist          [37mCreates tarballs of the files of the project.[00m'
	@echo '[00m    - [01;32minstall       [37mInstalls the project.[00m'
	@echo '[00m    - [01;32mclean         [37mRemoves compiled files.[00m'
	@echo '[00m    - [01;32muninstall     [37mDeinstalls the project.[00m'
	@echo ''
	@echo '[01;37mCLI-modifiable variables:[00m'
	@echo '    - [01;34mCC            [37m${CC}[00m'
	@echo '    - [01;34mCFLAGS        [37m${CFLAGS}[00m'
	@echo '    - [01;34mLDFLAGS       [37m${LDFLAGS}[00m'
	@echo '    - [01;34mDESTDIR       [37m${DESTDIR}[00m'
	@echo '    - [01;34mPREFIX        [37m${PREFIX}[00m'
	@echo '    - [01;34mBINDIR        [37m${BINDIR}[00m'
	@echo '    - [01;34mLIBDIR        [37m${LIBDIR}[00m'
	@echo '    - [01;34mSHAREDIR      [37m${SHAREDIR}[00m'
	@echo '    - [01;34mINCLUDEDIR    [37m${INCLUDEDIR}[00m'
	@echo '    - [01;34mLUA_VERSION   [37m${LUA_VERSION}[00m'
	@echo ''
	@echo '[01;37mProject targets: [00m'
	@echo '    - [01;33mmain.lua      [37mscript[00m'
	@echo ''
	@echo '[01;37mMakefile options:[00m'
	@echo '    - gnu:          false'
	@echo '    - colors:       true'
	@echo ''
	@echo '[01;37mRebuild the Makefile with:[00m'
	@echo '    zsh ./build.zsh -c'
.PHONY: all subdirs clean distclean dist install uninstall help

