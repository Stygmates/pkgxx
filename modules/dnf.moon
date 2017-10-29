
{
	installDependency: (name) =>
		fs.execute context: self, "dnf install -qy '#{name}'"
}

