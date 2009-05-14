GtkConcreteWidget subclass: GtkNamespaceWidget [
    | namespacesTree model |

    initialize [
	<category: 'initialization'>

	self mainWidget: self buildTreeView
    ]

    model [
	<category: 'accessing'>

	^ GtkNamespaceModel current model
    ]

    buildTreeView [
	<category: 'user interface'>
    
	| col render |
	namespacesTree := GTK.GtkTreeView new 
	    setModel: self model;
	    expandAll;
	    connectSignal: 'button-press-event' to: self selector: #'onPress:event:' userData: nil;
	    yourself.
	col := (GTK.GtkTreeViewColumn new)
		packStart: (render := GTK.GtkCellRendererText new) expand: true;
		addAttribute: render attribute: 'text' column: 0;
		setTitle: 'Namespaces';
		setSortIndicator: true;
		setSortColumnId: 0;
		setClickable: false;
		setSortOrder: GTK.Gtk gtkSortAscending;
		yourself.
	namespacesTree insertColumn: col position: -1.
	namespacesTree getSelection setMode: GTK.Gtk gtkSelectionBrowse.
	GtkNamespaceModel current isSorted 
	    ifFalse: [ 
		col signalEmitByName: 'clicked' args: {}.
		GtkNamespaceModel current sorted: true ].
	^ GTK.GtkScrolledWindow withChild: namespacesTree
    ]

    onPress: aGtkWidget event: aGdkEvent [
	<category: 'button event'>

	| menu aGdkButtonEvent |
        aGdkButtonEvent := aGdkEvent castTo: GTK.GdkEventButton type.
	aGdkButtonEvent button value = 3 ifFalse: [ ^ false ].
	menu := GTK.GtkMenu new.
	menu appendMenuItems: {{'Add a namespace'. self. #newNamespace}.
	    {'Rename a namespace'. self. #renameNamespace}.
	    {'Delete a namespace'. self. #deleteNamespace}.
	    {}.
	    {'Inspect a namespace'. self. #inspectNamespace}.
	    {}.
	    {'File out a namespace'. self. #fileoutNamespace}}.
	menu attachToWidget: namespacesTree detacher: nil.
	menu popup: nil parentMenuItem: nil func: nil data: nil button: 3 activateTime: aGdkButtonEvent time value.
	menu showAll.
	^ true
    ]

    whenSelectionChangedSend: aSelector to: anObject [
	<category: 'events'>

	namespacesTree getSelection
	    connectSignal: 'changed' to: anObject selector: aSelector userData: nil
    ]

    hasSelectedNamespace [
	<category: 'testing'>

	^ namespacesTree getSelection getSelected isNil not
    ]

    selectedIter [
	<category: 'accessing'>

	| iter |
        ^ (iter := namespacesTree getSelection getSelected) ifNil: [ self error: 'Nothing is selected' ]
    ]

    selectedNamespace [
	<category: 'accessing'>

	^ self findNamespace: (self model getOop: self selectedIter column: 0)
    ]

    selectANamespace: aNamespace [
	<category: 'item selection'>

	| selection |
	selection := namespacesTree getSelection.
	selection unselectAll.
	selection selectIter: (self findIterInANamespace: aNamespace)
    ]

    findIterInANamespace: aNamespace [
	<category: 'item selection'>

	^ GtkNamespaceModel current findIterInANamespace: aNamespace
    ]
    
    findNamespace: aString [
	<category: 'searching'>

	| result |
	(result := self findNamespace: aString from: Smalltalk) = self ifTrue: [self error: 'Namespace ', aString, 'not found'].
	^ result
    ]

    findNamespace: aString from: aNamespace [
	<category: 'searching'>

	aNamespace displayString = aString ifTrue: [^ aNamespace].
	
	aNamespace subspacesDo: [ :each | | result |
	    (result := self findNamespace: aString from: each) = self 
		ifFalse: [^ result]]
    ]
]

