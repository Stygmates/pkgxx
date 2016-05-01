
{
	installDependency: (name) ->
		os.execute "apt install -y '#{name}'"
}

