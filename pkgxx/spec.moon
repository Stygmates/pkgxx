#!/usr/bin/env moon

lpeg = require "lpeg"

{:map} = require "pkgxx.utils"

{:P, :S, :R} = lpeg

_M = {}

_M.Declaration = class
	new: (variable, value) =>
		@type = "declaration"
		@variable = variable
		@value = value

_M.ListDeclaration = class
	new: (variable, values) =>
		@type = "list declaration"
		@variable = variable
		@values = values

_M.Section = class
	new: (title, content) =>
		@type = "section"
		@title = title
		@content = content

_M.parse = (text) ->
	state = {
		position: 0
	}

	update_error_position = P (text, position) ->
		state.position = position
		position


	StartOfIdentifier =  R("az") + R("AZ")
	BodyOfIdentifier =   StartOfIdentifier + R("09") + S("-+/*_.")

	NewLine =            P("\n") + P("\r\n")
	InlineSpace =        S " \t"
	Space =              InlineSpace + NewLine
	StartOfComment =     P "#"
	EndOfComment =       NewLine
	StartOfSection =     P "@"

	DeclarationSeparator = P ":"
	ListItemMarker =     P "-"

	Identifier = StartOfIdentifier * BodyOfIdentifier^0 / => self

	Comment = StartOfComment * (P(1) - EndOfComment)^0 / =>
		{type: "comment", content: self}

	SectionHeader = StartOfSection * Identifier / => @
	SectionContent = ((P(1) - NewLine)^0 * NewLine - SectionHeader)^0 / => @
	Section = SectionHeader * NewLine * SectionContent / (title, content) ->
		{type: "section", :title, :content}

	Things = (P(1) - NewLine)^0 / =>
		self

	DeclarationValue = InlineSpace^0 * Things / => @

	SimpleDeclaration = Identifier * DeclarationSeparator * DeclarationValue / (variable, value) ->
		{type: "declaration", :variable, :value}

	ListItem = ListItemMarker * InlineSpace^0 * Things / => @

	ListDeclaration = Identifier * DeclarationSeparator * InlineSpace^0 * NewLine * (InlineSpace^0 * ListItem * NewLine)^1 / (...) =>
		{
			type: "list declaration",
			variable: self,
			values: {...}
		}

	Declaration = ListDeclaration + SimpleDeclaration

	Grammar = Space^0 * (((Comment * NewLine * Space^0) + (Declaration * NewLine * Space^0) + Section))^0 * P -1
	Grammar /= (...) ->
		{...}

	a, e = Grammar\match text
	unless a
		error "syntax error", 2

	setmetatable a, __index: _M

_M.getVariable = (identifier) =>
	for element in *@
		switch element.type
			when "declaration"
				if identifier == element.variable
					return element.value

_M.evaluate = (ast, preDefinitions) ->
	@ = setmetatable {}, __index: _M

	for element in *ast
		success, newElement = pcall -> switch element.type
			when "comment"
				nil
			when "declaration"
				_M.Declaration element.variable,
					element.value\gsub "%%{([^%%]*)}", (identifier) ->
						substitution = @\getVariable(identifier) or preDefinitions[identifier]

						unless substitution
							error {"variable not declared beforehand: #{identifier}"}, 0

						substitution
			when "list declaration"
				_M.ListDeclaration element.variable,
					map element.values, (value) ->
						value\gsub "%%{([^%%]*)}", (identifier) ->
							substitution = @\getVariable(identifier) or preDefinitions[identifier]

							unless substitution
								error {"variable not declared beforehand: #{identifier}"}, 0

							substitution
			when "section"
				_M.Section element.title,
					element.content\gsub "%%{([^%%]*)}", (identifier) ->
						substitution = @\getVariable(identifier) or preDefinitions[identifier]

						unless substitution
							error {"variable not declared beforehand: #{identifier}"}, 0

						substitution

		if success
			if newElement
				table.insert self, newElement
		else
			if type(newElement) == "table"
				return nil, newElement[1]
			else
				error newElement, 0

	@

_M

