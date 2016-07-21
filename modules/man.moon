
ui = require "pkgxx.ui"
fs = require "pkgxx.fs"

{
	postBuildHook: =>
		ui.detail "Compressing manpages..."

		fs.changeDirectory (@\packagingDirectory!), ->
			prefix = @\parse @context\getPrefix "mandir"

			-- FIXME: hardcoded directory spotted.
			unless fs.attributes "./#{prefix}"
				ui.debug "No manpage found: not compressing manpages."
				return

			find = io.popen "find ./#{prefix} -type f"

			file = find\read "*line"
			while file
				unless file\match "%.gz$" or file\match "%.xz$" or
				       file\match "%.bz2$"
					ui.debug "Compressing manpage: #{file}"

					switch @context.compressionMethod
						when "gz"
							os.execute "gzip -9 '#{file}'"
						when "bz2"
							os.execute "bzip2 -9 '#{file}'"
						when "xz"
							os.execute "xz -9 '#{file}'"

				file = find\read "*line"

			find\close!
}

