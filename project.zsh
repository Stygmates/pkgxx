
package=pkgxx
version=0.0.1

variables=(LUA_VERSION 5.2)

# main.moon -> main.in -> main.lua
targets=(main.lua main.in)
type[main.in]=moon
type[main.lua]=script
sources[main.in]="main.moon"
sources[main.lua]="main.in"
auto[main.in]=true
nodist[main.in]=true
filename[main.lua]="pkgxx"

for i in pkgxx/*.moon pkgxx.moon; do
	i="${i%.moon}.lua"
	targets+=($i)
	type[$i]=moon
	auto[$i]=true

	case "$i" in
		pkgxx.moon)
			install[$i]='$(SHAREDIR)/lua/$(LUA_VERSION)' ;;
		*)
			install[$i]='$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx' ;;
	esac
done

for i in modules/*.moon; do
	i="${i%.moon}.lua"
	targets+=($i)
	type[$i]=moon
	auto[$i]=true
	install[$i]='$(SHAREDIR)/pkgxx'
done


dist=(project.zsh Makefile)

