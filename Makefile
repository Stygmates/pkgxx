
PREFIX := /usr/local
LDIR := ${PREFIX}/share/lua/5.1
DESTDIR :=

build:
	moonc *.moon
	moonc */*.moon

install: build
	cp *.lua ${DESTDIR}${LDIR}
	mkdir -p ${DESTDIR}${LDIR}/pkgxx
	cp pkgxx/*.lua ${DESTDIR}${LDIR}/pkgxx/
	mkdir -p ${DESTDIR}${PREFIX}/share/pkgxx
	cp -r modules/*.lua ${DESTDIR}${PREFIX}/share/pkgxx/

clean:
	for i in *.moon; do rm $${i%%.moon}.lua; done
	for i in */*.moon; do rm $${i%%.moon}.lua; done

