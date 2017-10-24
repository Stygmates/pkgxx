
--- Container for parsed URLs and a few additional metadata.
--
-- @classmod Source
---

Class = require "pkgxx.class"

ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

local Source

--- Name of the local file in which to store the source once downloaded.
-- @attribute filename

--- URL of the sources to download.
--
-- The @{protocol} field does not need to match the URL’s protocol.
--
-- @attribute url

--- Protocol used to download.
-- @attribute protocol

Source = Class "Source",
	---
	-- Empty constructor.
	--
	-- Attributes can be set by passing them through `arg`.
	-- Example below.
	--
	-- ```
	-- Source
	--   protocol: "git"
	--   filename: "local_name"
	--   url: "https://github.com/Lukc/pkgxx"
	-- ```
	--
	-- @param arg (table) Table of named parameters.
	__init: (arg) =>
		@protocol = arg.protocol
		@filename = arg.filename
		@url =      arg.url

	__class: {
		---
		-- Parses a URL string and converts it into a Source.
		-- 
		-- @param string (string) Input string to parse.
		-- @constructor
		fromString: (string) ->
			url = string\gsub "%s*->%s*.*", ""
			protocol = url\gsub ":.*", ""
			protocol = url\match "^([^ ]*):"
			filename = string\match "->%s*(%S*)$"

			unless filename
				filename = url\match ":(%S*)"
				filename = (filename or url)\gsub ".*/", ""

			-- Aliases and stuff like git+http.
			if protocol
				protocol = protocol\gsub "+.*", ""
			url = url\gsub ".*+", ""

			Source {
				protocol: protocol,
				filename: filename,
				url: url
			}

		---
		-- Converts a Lua variable into a Source.
		-- 
		--   - Parses it if it’s a string.
		--   - Returns an empty array if it’s nil.
		--   - Will try to parse it as an array of strings otherwise.
		--     Things will probably go wrong at this point, however.
		--
		-- @param variable (object) Input value to convert.
		-- @constructor
		fromVariable: (variable) ->
			sources = switch type variable
				when "string"
					{ variable }
				when "nil"
					{}
				else
					variable

			for i = 1, #sources
				sources[i] = Source.fromString sources[i]

			sources
	}

	---
	-- Sources can be safely converted to debug strings that will show @{protocol}, @{url} and @{filename}.
	__tostring: =>
		"<Source: (#{@protocol}) #{@url} -> #{@filename}>"

	---
	-- Downloads a source.
	--
	-- Access to a @{Context} is needed to obtain pkg++ modules and downloader backends, as well as the configuration of which directories should store the sources.
	--
	-- @param context (Context) Context to use to access backends and configuration.
	download: (context) =>
		{:filename, :url, :protocol} = self

		if protocol
			fs.changeDirectory context.sourcesDirectory, ->
				module = context.modules[protocol]
				if module and module.download
					module.download self, context
				else
					ui.error "Does not know how to download: #{url}"
		else
			-- Files are built-in.
			if fs.attributes filename
				ui.detail "Copying file: #{filename}"
				a = os.execute "cp '#{filename}' '#{context.sourcesDirectory}/#{filename}'"

				if (type a) == "number" then
					a = a == 0

				return a
			else
				ui.detail "Already downloaded: #{filename}."
				true

Source

