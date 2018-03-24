#!/usr/bin/env moon

lpeg = require "lpeg"

{:P, :S, :R} = lpeg

parse = (text) ->
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
	a

{:parse}

