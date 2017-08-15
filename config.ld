project = 'pkgxx'
description = 'Extensible packages builder.'
full_description = 'Documentation for the pkgxx projects’ API and modules.'
file = { 'pkgxx.moon', 'pkgxx', 'main.moon', 'modules' }
format = 'markdown'
style = 'doc/css'
template = 'doc/css'
ext = "xhtml"
kind_names = {
	script = "Programs",
	topic = "Other"
}
examples = {
    'doc/examples/'
}
readme = {
	'doc/other/Introduction.md'
}

new_type('attribute', 'Attributes', false, "summary")

