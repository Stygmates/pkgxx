
LUA_VERSION := 5.1

PREFIX := /usr/local
BINDIR := ${PREFIX}/bin
LDIR   := ${PREFIX}/share/lua/${LUA_VERSION}
DESTDIR :=

build:
	moonc *.moon
	moonc */*.moon
	echo "#!/usr/bin/env lua" > pkgxx.tmp
	cat main.lua >> pkgxx.tmp
	chmod +x pkgxx.tmp
	mv pkgxx.tmp main.lua

install: build
	mkdir -p ${DESTDIR}${LDIR}/pkgxx
	cp pkgxx.lua ${DESTDIR}${LDIR}
	cp pkgxx/*.lua ${DESTDIR}${LDIR}/pkgxx/
	install -m0755 main.lua ${DESTDIR}${BINDIR}/pkgxx
	mkdir -p ${DESTDIR}${PREFIX}/share/pkgxx
	cp -r modules/*.lua ${DESTDIR}${PREFIX}/share/pkgxx/

clean:
	for i in *.moon; do rm -f $${i%%.moon}.lua; done
	for i in */*.moon; do rm -f $${i%%.moon}.lua; done

