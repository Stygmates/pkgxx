
fs = require "pkgxx.fs"

commonCheck = =>
	fs.attributes "#{@dirname}/autoload" or
		fs.attributes "#{@dirname}/plugin"

{
	canConfigure: commonCheck
	canBuild: commonCheck
	canInstall: commonCheck

	configure: =>
		true
	build: =>
		true
	install: =>
		fs.execute @, @\parse [[
			V=`vim --version | head -n1 | cut -d ' ' -f 5 | tr -d .`

			mkdir -p %{pkg}%{sharedir}/vim/vim$V

			cp -r %{dirname}/*/ %{pkg}%{sharedir}/vim/vim$V/
		]]

}

