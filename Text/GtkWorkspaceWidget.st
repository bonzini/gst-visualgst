GtkTextWidget subclass: GtkWorkspaceWidget [
    | variableTracker object |
    
    popupMenuOn: aGtkWidget menu: aGtkMenu [
	<category: 'events'>

	| menuitem |
    
	menuitem := GTK.GtkMenuItem new.
	menuitem show.
	aGtkMenu append: menuitem.
	menuitem := GTK.GtkMenuItem newWithLabel: 'Do It'.
	menuitem
	    show;
	    connectSignal: 'activate' to: self selector: #doIt.
	aGtkMenu append: menuitem.
	menuitem := GTK.GtkMenuItem newWithLabel: 'Print It'.
	menuitem
	    show;
	    connectSignal: 'activate' to: self selector: #printIt.
	aGtkMenu append: menuitem.
	menuitem := GTK.GtkMenuItem newWithLabel: 'Inspect It'.
	menuitem
	    show;
	    connectSignal: 'activate' to: self selector: #inspectIt.
	aGtkMenu append: menuitem.
	menuitem := GTK.GtkMenuItem newWithLabel: 'Debug It'.
	menuitem
	    show;
	    connectSignal: 'activate' to: self selector: #debugIt.
	aGtkMenu append: menuitem.
    ]

    initialize [
	<category: 'intialization'>

	variableTracker := (WorkspaceVariableTracker new)
				initialize;
				yourself.
	object := variableTracker object.
	super initialize.
    ]

    variableTracker [
	<category: 'evaluation'>

        ^variableTracker
    ]

    object: anObject [
	<category: 'evaluation'>

        variableTracker := nil.
        object := anObject.
    ]

    targetObject [
	<category: 'evaluation'>

        ^ object
    ]

    beforeEvaluation [
        <category: 'smalltalk event'>

	| text nodes |
        variableTracker isNil ifTrue: [^self].
	text := self selectedText.
	nodes := STInST.RBParser parseExpression: text onError: [ :s :p | self error: s ].
	variableTracker visitNode: nodes
    ]

    afterEvaluation [
        <category: 'smalltalk event'>

	variableTracker changed
    ]

    doIt [
	<category: 'smalltalk event'>

	DoItCommand executeOn: self
    ]

    debugIt [
	<category: 'smalltalk event'>

	DebugItCommand executeOn: self
    ]

    inspectIt [
	<category: 'smalltalk event'>

	InspectItCommand executeOn: self
    ]

    printIt [
	<category: 'smalltalk event'>

	PrintItCommand executeOn: self
    ]
]
