GtkMainWindow subclass: GtkInspector [
    | object notebookWidget inspectorWidget browserWidget workspaceWidget |

    GtkInspector class >> openOn: anObject [
	<category: 'user interface'>

	^ (self new)
	    initialize;
	    object: anObject;
	    showAll;
	    yourself
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

    initialize [
	<category: 'initialization'>
	
	super initialize.
	self
	    title: 'Inspector';
	    createMenus;
	    createToolbar;
	    createStatusBar;
	    centralWidget: self buildCentralWidget
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
				initialize;
				showAll;
				yourself
    ]

    buildWorkspaceWidget [
	<category: 'user interface'>

	^ workspaceWidget := (GtkInspectorSourceWidget new)
				initialize;
				showAll;
				yourself
    ]

    buildBrowserWidget [
	<category: 'user interface'>

	^ browserWidget := (GtkInspectorBrowserWidget new)
	    initialize;
	    showAll;
	    yourself
    ]

    createEditMenus [
	<category: 'user interface'>

	^ self createMenuEntry: {#('Cut' #cut '').
	    #('Copy' #copy '').
	    #('Paste' #paste '').
	    #().
	    #('Select all' #selectAll '')}
    ]

    createFileMenus [
	<category: 'user interface'>

	^ self createMenuEntry: {#('New workspace' #newWorkspace '').
	    #().
	    #('Open' #open '').
	    #('Save' #saveImage '').
	    #('Save as...' #saveImageAs '').
	    #().
	    #('Print' #print '').
	    #().
	    #('Save image' #saveImage '').
	    #('Save image as...' #saveImageAs '').
	    #().
	    #('Quit' #quit '')}
    ]

    createMenus [
	<category: 'user interface'>

	self addMenuItem: 'File' withSubmenu: self createFileMenus.
	self addMenuItem: 'Edit' withSubmenu: self createEditMenus.
	self addMenuItem: 'Smalltalk' withSubmenu: self createToolsMenus.
    ]

    createStatusBar [
	<category: 'user interface'>

	self statusMessage: 'Gtk Inspector'
    ]

    createToolbar [
	<category: 'user interface'>

	self
	    appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-new');
	    appendSeparator;
	    appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-save');
	    appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-save-as');
	    appendSeparator;
	    appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-cut');
	    appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-copy');
	    appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-paste');
	    appendSeparator;
	    appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-execute')
    ]

    createToolsMenus [
	<category: 'user interface'>

	^ self createMenuEntry: 
	    {#('Browser' #classBrowser '').
	    #('Workspace' #workspace '').
	    #('Inspector' #gtkInspector '').
	    #().
	    #('GtkDemo' #gtkDemo '').
	    #('SqueakZilla' #squeakzilla '')}
    ]
]

