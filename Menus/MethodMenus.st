MenuBuilder subclass: MethodMenus [

    MethodMenus class >> menus [

	^ {SenderMethodMenu.
        ImplementorMethodMenu.
	MenuSeparator.
        DeleteMethodMenu.
	MenuSeparator.
        FileOutMethodMenu.
	MenuSeparator.
        InspectMethodMenu}
    ]
]
