MenuBuilder subclass: NamespaceMenus [

    NamespaceMenus class >> menus [

	^ {AddNamespaceMenu.
        DeleteNamespaceMenu.
        RenameNamespaceMenu.
	MenuSeparator.
        FileOutNamespaceMenu.  
	MenuSeparator.
        InspectNamespaceMenu}
    ]
]
