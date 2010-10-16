MenuBuilder subclass: ToolsMenus [

    ToolsMenus class >> menus [

	| menu |
	menu := {OpenWindowCommand.
                MenuSeparator.
		OpenWorkspaceCommand.
                OpenTabbedBrowserCommand.
		OpenSUnitCommand.
                MenuSeparator.
                OpenSenderCommand.
		OpenImplementorCommand.
		OpenPackageBuilderCommand} asOrderedCollection.

        GtkWebView hasWebkit ifTrue: [ menu := menu, {MenuSeparator.
            OpenAssistantCommand.
            MenuSeparator.
            OpenWebBrowserCommand} ].

        ^menu
    ]
]
