
Class = require "pkgxx.class"

local Watch

Watch = Class
	__init: (arg) =>
		@warnings = {}

		@url = arg.url
		@selector = arg.selector
		@lasttar = arg.lasttar
		@execute = arg.execute

		@subs = do
			for i = 1, #(arg.subs or {})
				pair = arg.subs[i]

				unless (type pair) == "table" and #pair == 2
					table.insert @errors, "Invalid substitution ##{i}. Substitution is not a pair."

					continue

				unless (type pair[1] == "string") and (type pair[2] == "string")
					table.insert @errors, "Invalid substitution ##{i}. Substitution is not a pair of strings."

					continue

				pair

	__class:
		fromSpec: (arg) ->
			watch = Watch arg

			entries = do
				for i in *{"selector", "lasttar", "execute"}
					continue unless watch[i]
					i

			if #entries > 1
				return nil, "You should only provide one of “selector”, “lasttar” or “execute”."
			elseif #entries == 0
				return nil, "You should provide one of “selector”, “lasttar” or “execute”."

			watch

	__tostring: =>
		"<pkgxx:Watch, url=\"#{@url}\", #{#@subs} subs>"


	getLatestVersion: (context) =>
		local p
		-- FIXME: We need to abstract those curl calls.
		-- FIXME: sort -n is a GNU extension.
		-- FIXME: hx* come from the html-xml-utils from the w3c. That’s
		--        an unusual external dependency we’d better get rid of.
		--        We could switch to https://github.com/msva/lua-htmlparser,
		--        but there could be issues with Lua 5.1. More testing needed.
		if @watch.selector
			context\debug "Using the “selector” method."
			p = io.popen "curl -sL '#{@watch.url}' | hxnormalize -x " ..
				"| hxselect -c '#{@watch.selector}' -s '\n'"
		elseif @watch.lasttar
			context\debug "Using the “lasttar” method."
			p = io.popen "curl -sL '#{@watch.url}' | hxnormalize -x " ..
				"| hxselect -c 'a' -s '\n' " ..
				"| grep '#{@watch.lasttar}' " ..
				-- FIXME +V is a gnu extension.
				"| sed 's&#{@watch.lasttar}&&;s&\\.tar\\..*$&&' | sort -rV"
		elseif @watch.execute
			context\debug "Executing custom script."
			p = io.popen @watch.execute

		version = p\read "*line"
		success, _, r = p\close!

		-- 5.1 compatibility sucks.
		unless (r and r == 0 or success) and version
			return nil, nil, "could not check", "child process failed"

		if version
			version = version\gsub "^%s*", ""
			version = version\gsub "%s*$", ""

		for pair in *@watch.subs
			unless (type pair) == "table" and #pair == 2
				context\warning "Invalid substitution. Substitution is not a pair."
				continue

			unless (type pair[1] == "string") and (type pair[2] == "string")
				context\warning "Invalid substitution. Substitution is not a pair of strings."

				continue

			version = version\gsub pair[1], pair[2]

		return version == @version, version

Watch

