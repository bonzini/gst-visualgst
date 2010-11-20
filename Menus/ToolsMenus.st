MenuBuilder subclass: ToolsMenus [

    ToolsMenus class >> menus [

	| menu |
	menu := {OpenImplementorCommand.
		OpenSenderCommand.
		OpenSUnitCommand.
		OpenPackageBuilderCommand} asOrderedCollection.

        GtkWebView hasWebkit ifTrue: [ menu := menu, {MenuSeparator.
            OpenAssistantCommand.
            MenuSeparator.
            OpenWebBrowserCommand} ].

        ^menu
    ]
]
