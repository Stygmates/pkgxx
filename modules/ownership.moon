
{
	postBuildHook: =>
		local uid, gid

		@\detail "Checking ownership..."

		with io.popen "id -u"
			uid = tonumber \read "*line"
			\close!

		with io.popen "id -g"
			gid = tonumber \read "*line"
			\close!
}

