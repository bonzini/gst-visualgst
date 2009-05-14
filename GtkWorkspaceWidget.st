GtkConcreteWidget subclass: GtkWorkspaceWidget [
    | textview variableTracker object |
    
    popupMenuOn: aGtkWidget menu: aGtkMenu [
	<category: 'events'>

	| menuitem |
    
	menuitem := GTK.GtkMenuItem new.
	menuitem show.
	aGtkMenu append: menuitem.
	menuitem := GTK.GtkMenuItem newWithLabel: 'Do It'.
	menuitem
	    show;
	    connectSignal: 'activate' to: self selector: #doIt userData: nil.
	aGtkMenu append: menuitem.
	menuitem := GTK.GtkMenuItem newWithLabel: 'Print It'.
	menuitem
	    show;
	    connectSignal: 'activate' to: self selector: #printIt userData: nil.
	aGtkMenu append: menuitem.
	menuitem := GTK.GtkMenuItem newWithLabel: 'Inspect It'.
	menuitem
	    show;
	    connectSignal: 'activate' to: self selector: #inspectIt userData: nil.
	aGtkMenu append: menuitem.
	menuitem := GTK.GtkMenuItem newWithLabel: 'Debug It'.
	menuitem
	    show;
	    connectSignal: 'activate' to: self selector: #debugIt userData: nil.
	aGtkMenu append: menuitem
    ]

    initialize [
	<category: 'intialization'>

	self mainWidget: self buildTextView.
	variableTracker := (WorkspaceVariableTracker new)
				initialize;
				yourself.
	object := variableTracker objectClass new
    ]

    buildTextView [
	<category: 'user interface'>

	textview := (GTK.GtkTextView newWithBuffer: GTK.GtkTextBuffer new)
			connectSignal: 'populate-popup' to: self selector: #popupMenuOn:menu: userData: nil;
			yourself.
	^ GTK.GtkScrolledWindow withChild: textview
    ]

    text: aString [
	<category: 'text accessing'>

	textview getBuffer setText: aString
    ]

    selectedText [
	<category: 'text accessing'>

	^ textview getBuffer getHasSelection
                ifTrue: [ | iter |
                        iter := textview getBuffer getSelectionBounds ifNil: [^ self].
                        textview getBuffer getText: (iter at: 1) end: (iter at: 2) includeHiddenChars: false ]
                ifFalse: [ textview getBuffer text ].
    ]

    doIt [
	<category: 'events'>

	| text nodes |
	text := self selectedText.
	nodes := STInST.RBParser parseExpression: text onError: [ :s :p | self error: s ].
	variableTracker visitNode: nodes.
        ^ Behavior
	    evaluate: text
	    to: object
	    ifError: [ :fname :lineNo :errorString | self error: errorString ]
    ]

    printIt [
	<category: 'events'>

	textview getBuffer insertAtCursor: (self doIt displayString) 
    ]

    inspectIt [
	<category: 'events'>

	GtkInspector openOn: self doIt
    ]

    copy [
        <category: 'text editing'>

        textview signalEmitByName: 'copy-clipboard' args: {}
    ]

    cut [
        <category: 'text editing'>

        textview signalEmitByName: 'cut-clipboard' args: {}
    ]

    paste [
        <category: 'text editing'>

        textview signalEmitByName: 'paste-clipboard' args: {}.
    ]

    selectAll [
        <category: 'text editing'>

        textview signalEmitByName: 'select-all' args: {true}.
    ]
]
