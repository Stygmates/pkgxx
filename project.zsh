
package=pkgxx
version=0.0.1

variables=(LUA_VERSION 5.1)

# Valid values: moon, script. Set to “moon” to compile to Lua.
moon=script

for i in pkgxx/*.moon pkgxx.moon; do
	if [[ "$moon" == moon ]]; then
		i="${i%.moon}.lua"
	fi

	targets+=($i)
	type[$i]=$moon
	auto[$i]=true

	case "$i" in
		pkgxx.lua|pkgxx.moon)
			install[$i]='$(SHAREDIR)/lua/$(LUA_VERSION)' ;;
		*)
			install[$i]='$(SHAREDIR)/lua/$(LUA_VERSION)/pkgxx' ;;
	esac
done

for i in modules/*.moon; do
	if [[ "$moon" == moon ]]; then
		i="${i%.moon}.lua"
	fi

	targets+=($i)
	type[$i]=$moon
	auto[$i]=true
	install[$i]='$(SHAREDIR)/pkgxx'
done

if [[ $moon == moon ]]; then
	# main.moon -> main.in -> main.lua
	targets+=(main.lua main.in)
	type[main.in]=script
	type[main.lua]=$moon
	sources[main.in]="main.moon"
	sources[main.lua]="main.in"
	auto[main.in]=true
	install[main.in]=-
	nodist[main.in]=true
	filename[main.lua]="pkgxx"
else
	targets+=(main)
	type[main]=script
	sources[main]="main.moon"
	filename[main]=pkgxx
fi

dist=(
	**/*.moon
	# Build system.
	project.zsh Makefile
	# Documentation.
	config.ld doc/css/ldoc.{css,ltp}
	doc/examples/*.moon
	README.md
)

