MenuBuilder subclass: ClassMenus [

    ClassMenus class >> menus [

	^ {AddClassMenu.
        RenameClassMenu.
        DeleteClassMenu.
	MenuSeparator.
        FileOutClassMenu.  
	MenuSeparator.
        InspectClassMenu}
    ]
]

