GTK.GtkTreeView class extend [

    newWithTextColumn: aGtkModel title: aString [
        <category: 'user interface'>

        | view col render |
        view := self new
	    setModel: aGtkModel;
	    yourself.
        col := (GtkTreeViewColumn new)
	    packStart: (render := GTK.GtkCellRendererText new) expand: true;
	    addAttribute: render attribute: 'text' column: 0;
	    setTitle: aString;
	    yourself.
        view insertColumn: col position: -1.
    ^ view
    ]

    newWithSortedTextColumn: aGtkModel title: aString [
    <category: 'instance creation'>

        | view col render |
        view := self new
                    setModel: aGtkModel;
                    yourself.
        col := (GtkTreeViewColumn new)
                packStart: (render := GtkCellRendererText new) expand: true;
                addAttribute: render attribute: 'text' column: 0;
                setTitle: aString;
                setSortIndicator: true;
                setSortColumnId: 0;
                setSortOrder: Gtk gtkSortAscending;
                yourself.
        view
            insertColumn: col position: -1.
    ^ view
    ]
]

GTK.GtkTreeView extend [

    hasSelectedItem [
	<category: 'accessing'>

	^ self getSelection getSelected isNil not
    ]

    numberOfItems [
	<category: 'accessing'>

	^ self getModel iterNChildren: nil
    ]

    selectedIter [
	<category: 'accessing'>

	^ self getSelection getSelected
    ]

    selectedIndex [
	<category: 'accessing'>

	self hasSelectedItem ifFalse: [ self error: 'Nothing is selected' ].
	^ (self getModel getPath: self selectedIter) getIndices value + 1
    ]
]
