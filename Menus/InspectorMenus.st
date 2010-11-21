MenuBuilder subclass: WorkspaceVariableMenus [

    TabsMenus class >> menus [

	^ {InspectItemCommand.
        MenuSeparator.
        InspectorDiveCommand.
        InspectorBackCommand}
    ]
]
