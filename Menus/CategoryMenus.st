MenuBuilder subclass: CategoryMenus [

    CategoryMenus class >> menus [

	^ {AddCategoryMenu.
        RenameCategoryMenu.
	MenuSeparator.
        FileOutCategoryMenu}
    ]
]

