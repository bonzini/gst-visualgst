GtkVisualGSTTool subclass: GtkInspector [
    | object notebookWidget inspectorWidget browserWidget workspaceWidget |

    GtkInspector class >> openOn: anObject [
	<category: 'user interface'>

	^ (self new)
	    initialize;
	    object: anObject;
	    showAll;
	    postInitialize;
	    yourself
    ]

    postInitialize [
        <category: 'initialization'>

	super postInitialize.
	browserWidget postInitialize.
	inspectorWidget postInitialize.
	workspaceWidget postInitialize.
    ]

    object: anObject [
	<category: 'accessor'>

	| objectClass |
	object := anObject.
	objectClass := object isClass ifTrue: [ object ] ifFalse: [ object class ].
	self title: 'Inspector on ', objectClass article, ' ', objectClass name.
	inspectorWidget object: object.
	workspaceWidget object: object.
	browserWidget
	    selectAClass: objectClass
    ]

    windowTitle [
	<category: 'initialization'>
	
	^'Inspector'
    ]

    buildCentralWidget [
	<category: 'intialize-release'>

	| trWidget wkWidget |
	notebookWidget := GTK.GtkNotebook new.
	trWidget := self buildInspectorView.
	wkWidget := self buildBrowserWidget mainWidget.
	^ notebookWidget
	    appendPage: trWidget tabLabel: (GTK.GtkLabel new: 'Basic');
	    appendPage: wkWidget tabLabel: (GTK.GtkLabel new: 'Methods');
	    showAll;
	    setCurrentPage: 0;
	    yourself
    ]

    buildInspectorView [
	<category: 'user interface'>

	^ GTK.GtkVPaned new
            pack1: self buildInspectorWidget mainWidget resize: true shrink: false;
            pack2: self buildWorkspaceWidget mainWidget resize: false shrink: true;
            yourself
    ]

    buildInspectorWidget [
	<category: 'user interface'>

	^ inspectorWidget := (GtkInspectorWidget new)
				parentWindow: window;
				initialize;
				inspector: self;
				showAll;
				yourself
    ]

    buildWorkspaceWidget [
	<category: 'user interface'>

	^ workspaceWidget := (GtkInspectorSourceWidget new)
				parentWindow: window;
				initialize;
				showAll;
				yourself
    ]

    buildBrowserWidget [
	<category: 'user interface'>

	^ browserWidget := (GtkInspectorBrowserWidget new)
				parentWindow: window;
				initialize;
				showAll;
				yourself
    ]

    createMenus [
	<category: 'user interface'>

	self addMenuItem: 'File' withSubmenu: self createFileMenus.
	self addMenuItem: 'Edit' withSubmenu: self createEditMenus.
	self addMenuItem: 'Smalltalk' withSubmenu: self createSmalltalkMenus.
	self addMenuItem: 'Tools' withSubmenu: self createToolsMenus.
    ]

    onFocusPerform: aSelector [
        <category: 'focus'>

        ^ notebookWidget getCurrentPage = 0 
            ifTrue: [ workspaceWidget hasFocus
                            ifTrue: [ workspaceWidget perform: aSelector ] ]
            ifFalse: [ browserWidget perform: aSelector ]
    ]

    cancel [
        <category: 'edit events'>

        self onFocusPerform: #cancel
    ]

    undo [
        <category: 'edit events'>

        self onFocusPerform: #undo
    ]

    redo [
        <category: 'edit events'>

        self onFocusPerform: #redo
    ]

    cut [
        <category: 'edit events'>

        self onFocusPerform: #cut
    ]

    copy [
        <category: 'edit events'>

        self onFocusPerform: #copy
    ]

    paste [
        <category: 'edit events'>

        self onFocusPerform: #paste
    ]

    selectAll [
        <category: 'edit events'>

        self onFocusPerform: #selectAll
    ]

    close [
        <category: 'file events'>

        browserWidget hasChanged ifFalse: [ ^ super close ].
        browserWidget doNotCheckCode.
        self saveCodeOnClose: [ super close ] onSave: [ browserWidget saveCode. super close ]
    ]

    delete: aGtkWidget event: aGdkEvent [
        <category: 'window events'>

        browserWidget hasChanged ifFalse: [ ^ window hideAll ].
        self saveCodeOnClose: [ window hideAll ] onSave: [ browserWidget saveCode. window hideAll ].
        ^ true
    ]

    saveCodeOnClose: closeEvent onSave: saveEvent [
        <category: 'saving'>

        | dialog |
        dialog := GTK.GtkMessageDialog
                                new: window
                                flags: GTK.Gtk gtkDialogDestroyWithParent
                                type: GTK.Gtk gtkMessageWarning
                                buttons: GTK.Gtk gtkButtonsNone
                                message: 'Save the code before exiting?'
                                tip: 'If you do not save, your changes to %1 will be lost...' % {browserWidget stateString}.

        dialog
            addButton: 'Close without saving' responseId: 0;
            addButton: 'Cancel' responseId: 2;
            addButton: 'Save' responseId: 1;
            showModalOnAnswer: [ :dlg :res |
                res = 0 ifTrue: closeEvent.
                res = 1 ifTrue: saveEvent.
                dlg destroy ].
    ]

    doIt [
        <category: 'smalltalk events'>

        self onFocusPerform: #doIt
    ]

    printIt [
        <category: 'smalltalk events'>

        self onFocusPerform: #printIt
    ]

    inspectIt [
        <category: 'smalltalk events'>

        self onFocusPerform: #inspectIt
    ]

    debugIt [
        <category: 'smalltalk events'>

        self onFocusPerform: #debugIt
    ]

    acceptIt [
        <category: 'smalltalk events'>

        browserWidget saveCode
    ]

    find [
	<category: 'user interface'>

	self onFocusPerform: #showFind
    ]

    replace [
	<category: 'user interface'>

	self onFocusPerform: #showReplace
    ]
]

