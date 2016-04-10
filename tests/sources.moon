
describe "pkgxx.sources", ->
	sources = require "pkgxx.sources"

	it "parses local sources", ->
		s = sources.parse "a"

		assert s.filename == "a"
		assert.is_nil s.protocol
		assert s.url == "a"

	it "parses simple protocol:file URLs", ->
		s = sources.parse "a:b"

		assert s.filename == "b"
		assert s.url == "a:b"
		assert s.protocol == "a"

	it "parses simple protocol:directories/file URLs", ->
		s = sources.parse "a:b/c"

		assert s.filename == "c"
		assert s.url == "a:b/c"
		assert s.protocol == "a"

	it "parses arrows", ->
		s = sources.parse "a:b -> c"

		assert s.filename == "c"
		assert s.url == "a:b"
		assert s.protocol == "a"

	it "parses user-defined protocols", ->
		s = sources.parse "p+a:b"

		assert s.filename == "b"
		assert s.url == "a:b"
		assert s.protocol == "p"

	it "parses user-defined protocols with arrows", ->
		s = sources.parse "p+a:b -> c"

		assert s.filename == "c"
		assert s.url == "a:b"
		assert s.protocol == "p"


	it "parses complex examples", ->
		s = sources.parse "foo+bar://hum/maybe/itll/works -> or-not"

		assert s.filename == "or-not"
		assert s.url == "bar://hum/maybe/itll/works"
		assert s.protocol == "foo"

