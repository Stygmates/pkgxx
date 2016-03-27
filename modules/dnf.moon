
{
	installDependency: (name) ->
		os.execute "dnf install -qy #{name}"
}

