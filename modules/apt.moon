
{
	installDependency: (name) =>
		fs.execute context: self, "apt install -y '#{name}'"
}

