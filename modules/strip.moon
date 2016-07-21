
{
	postBuildHook: =>
		ui.detail "Stripping binaries..."

		fs.changeDirectory (@\packagingDirectory!), ->
			find = io.popen "find . -type f"

			line = find\read "*line"
			while line
				p = io.popen "file -b '#{line}'"
				type = p\read "*line"
				p\close!

				if type\match ".*ELF.*executable.*not stripped"
					ui.debug "Stripping '#{line}'."
					os.execute "strip --strip-all '#{line}'"
				elseif type\match ".*ELF.*shared object.*not stripped"
					ui.debug "Stripping '#{line}'."
					os.execute "strip --strip-unneeded '#{line}'"
				elseif type\match "current ar archive"
					ui.debug "Stripping '#{line}'."
					os.execute "strip --strip-debug '#{line}'"

				line = find\read "*line"

			find\close!
}

