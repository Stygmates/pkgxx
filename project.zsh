
package=pkgxx
version="$(grep "^version = " main.moon | head -n 1 | cut -d \" -f 2)"

variables=(LUA_VERSION 5.3)

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

for i in doc/*.[0-9].md; do
	targets+=(${i%.md})
	type[${i%.md}]=man
	sources[${i%.md}]="$i"
done

dist=(
	**/*.moon
	# Build system.
	project.zsh Makefile
	# Documentation.
	doc/css/ldoc.{css,ltp}
	doc/examples/*.moon
	README.md
)

