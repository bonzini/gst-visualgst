GtkConcreteWidget subclass: GtkClassWidget [
    | classesTree column model namespace |

    GtkClassWidget >> on: aNamespace [
	^ (self new)
	    initialize;
	    namespace: aNamespace;
	    yourself
    ]

    initialize [
	<category: 'initialization'>

	self mainWidget: self buildTreeView
    ]

    namespace [
	<category: 'accessing'>
    
	^ namespace
    ]

    namespace: aNamespace [
	<category: 'accessing'>

	namespace := aNamespace.
	self refreshModel
    ]

    model [
	<category: 'accessing'>

	^ (GtkClassModel currentOn: self namespace)
	    model
    ]

    refreshModel [
	<category: 'events'>
	
	classesTree
	    setModel: self model;
	    expandAll.
	(GtkClassModel currentOn: self namespace) isSorted
            ifFalse: [
                column signalEmitByName: 'clicked' args: {}.
                (GtkClassModel currentOn: self namespace) sorted: true ].
    ]

    buildTreeView [
	<category: 'user interface'>
    
	| render |
	classesTree := GTK.GtkTreeView new 
	    setModel: self model;
	    expandAll;
	    connectSignal: 'button-press-event' to: self selector: #'onPress:event:' userData: nil;
	    yourself.
	column := (GTK.GtkTreeViewColumn new)
	    packStart: (render := GTK.GtkCellRendererText new) expand: true;
	    addAttribute: render attribute: 'text' column: 0;
	    setTitle: 'Class';
	    setSortColumnId: 0;
	    setClickable: false;
	    setSortOrder: GTK.Gtk gtkSortAscending;
	    yourself.
	classesTree insertColumn: column position: -1.
	classesTree getSelection setMode: GTK.Gtk gtkSelectionBrowse.
	(GtkClassModel currentOn: self namespace) isSorted 
	    ifFalse: [
		column signalEmitByName: 'clicked' args: {}.
		(GtkClassModel currentOn: self namespace) sorted: true ].
	^ GTK.GtkScrolledWindow withChild: classesTree
    ]

    onPress: aGtkWidget event: aGdkEvent [
        <category: 'button event'>

        | menu aGdkButtonEvent |
        aGdkButtonEvent := aGdkEvent castTo: GTK.GdkEventButton type.
        aGdkButtonEvent button value = 3 ifFalse: [ ^ false ].
        menu := GTK.GtkMenu new.
        menu appendMenuItems: {{'Add a class'. self. #newClass}.
            {'Rename a class'. self. #renameClass}.
            {'Delete a class'. self. #deleteClass}.
            {}.
            {'Inspect a class'. self. #inspectClass}.
            {}.
            {'File out a class'. self. #fileoutClass}}.
        menu attachToWidget: classesTree detacher: nil.
        menu popup: nil parentMenuItem: nil func: nil data: nil button: 3 activateTime: aGdkButtonEvent time value.
        menu showAll.
        ^ true
    ]

    whenSelectionChangedSend: aSelector to: anObject [
	<category: 'events'>

	classesTree getSelection
	    connectSignal: 'changed' to: anObject selector: aSelector userData: nil
    ]

    hasSelectedClass [
	<category: 'testing'>

	^ classesTree getSelection getSelected isNil not
    ]

    selectedClass [
	<category: 'accessing'>

	| iter string |
	(iter := classesTree getSelection getSelected) ifNil: [self error: 'Nothing is selected'].
	string := ((self model getOop: iter column: 0) subStrings: $ ) at: 1.
	^ self namespace classAt: string asSymbol
    ]

    selectAClass: aClass [
	<category: 'item selection'>

	| selection |
        selection := classesTree getSelection.
        selection unselectAll.
        selection selectIter: (self findIterInAClass: aClass)
    ]

    findIterInAClass: aClass [
        <category: 'item selection'>

	| result |

	result := (GtkClassModel currentOn: self namespace) findIterInAClass: aClass.
	classesTree scrollToCell: (self model getPath: result) column: nil useAlign: false rowAlign: 0.5 colAlign: 0.5.
	^ result 
    ]

    selectedIter [
	<category: 'accessing'>

	| iter |
	^ (iter := classesTree getSelection getSelected) ifNil: [ self error: 'Nothing is selected' ]
    ]
]

