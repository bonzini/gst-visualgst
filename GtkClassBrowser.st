GtkMainWindow subclass: GtkClassBrowser [
    | browserWidget |

    GtkClassBrowser class >> open [
	<category: 'user interface'>

	^ self openSized: 650@450
    ]

    aboutBrowser [
	<category: 'events'>

	(GTK.GtkAboutDialog new)
	    setVersion: GtkLauncher version;
	    setLicense: 'Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is furnished
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.';
	    setWebsite: GtkLauncher website;
	    setComments: 'This is a system browser for GNU Smalltalk.';
	    "setAuthors: {'Gwenael Casaccio'. 'Nicolas Petton'};"
	    setProgramName: 'GNU Smalltalk Browser';
	    runNonBlockingAndDestroy
    ]

    browser [
	<category: 'events'>
    ]

    classBrowser [
	<category: 'events'>
    ]

    undo [
	<category: 'edit events'>

	browserWidget undo
    ]

    redo [
	<category: 'edit events'>

	browserWidget redo
    ]

    gtkInspector [
	<category: 'events'>
	
	GtkInspector openOn: self
    ]

    fileoutNamespace [
	<category: 'namespace events'>

        | file |
        (GTK.GtkFileChooserDialog selectFolder: 'Save namespace as...' parent: window)
            runNonBlockingAndDo: [ :dlg :res |
                res = GTK.Gtk gtkResponseAccept ifTrue: [ self fileoutNamespace: dlg getCurrentFolder ].
                dlg destroy ].
    ]

    fileoutNamespace: aString [
	<category: 'namespace events'>

	browserWidget fileoutNamespace: aString
    ]

    fileoutProject [
        <category: 'namespace events'>

        browserWidget fileoutProject
    ]

    newNamespace [
	<category: 'namespace events'>

	browserWidget newNamespace
    ]

    renameNamespace [
	<category: 'namespace events'>

	browserWidget renameNamespace
    ]

    deleteNamespace [
	<category: 'namespace events'>

	browserWidget deleteNamespace
    ]

    inspectNamespace [
	<category: 'namespace events'>

	browserWidget inspectNamespace
    ]

    fileoutClass [
	<category: 'class events'>

        | file |
        (GTK.GtkFileChooserDialog save: 'Save Smalltalk class as...' parent: window)
            runNonBlockingAndDo: [ :dlg :res |
                res = GTK.Gtk gtkResponseAccept ifTrue: [ self fileoutClass: dlg getFilename ].
                dlg destroy ]
    ]

    fileoutClass: aString [
	<category: 'class events'>

	browserWidget fileoutClass: aString
    ]

    fileoutClassInProject [
	<category: 'class events'>

	browserWidget fileoutClassInProject
    ]

    newClass [
        <category: 'class events'>

	browserWidget newClass
    ]

    renameClass [
        <category: 'class events'>

	browserWidget renameClass
    ]

    deleteClass [
        <category: 'class events'>

	browserWidget deleteClass
    ]

    inspectClass [
	<category: 'class events'>

	browserWidget inspectClass
    ]

    newCategory [
	<category: 'category events'>

	browserWidget newCategory
    ]

    renameCategory [
	<category: 'category events'>

	browserWidget renameCategory
    ]

    deleteCategory [
	<category: 'category events'>

	browserWidget deleteCategory
    ]

    inspectCategory [
	<category: 'category events'>

	browserWidget inspectCategory
    ]

    fileoutCategory [
        <category: 'method events'>

        | file |
        (GTK.GtkFileChooserDialog save: 'Save Smalltalk category as...' parent: window)
            runNonBlockingAndDo: [ :dlg :res |
                res = GTK.Gtk gtkResponseAccept ifTrue: [ self fileoutCategory: dlg getFilename ].
                dlg destroy ]
    ]

    fileoutCategory: aString [
        <category: 'method events'>

        browserWidget fileoutCategory: aString
    ]

    newMethod [
	<category: 'method events'>

	browserWidget newMethod
    ]

    deleteMethod [
	<category: 'method events'>

	browserWidget deleteMethod
    ]

    inspectMethod [
	<category: 'method events'>

	browserWidget inspectMethod
    ]

    fileoutMethod [
	<category: 'method events'>

        | file |
        (GTK.GtkFileChooserDialog save: 'Save Smalltalk method as...' parent: window)
            runNonBlockingAndDo: [ :dlg :res |
                res = GTK.Gtk gtkResponseAccept ifTrue: [ self fileoutMethod: dlg getFilename ].
                dlg destroy ]
    ]

    fileoutMethod: aString [
        <category: 'method events'>

	browserWidget fileoutMethod: aString
    ]

    initialize [
	<category: 'initialization'>

	super initialize.
	self
	    title: 'GNU Smalltalk Browser';
	    createMenus;
	    createToolbar;
	    createStatusBar;
	    centralWidget: self buildClassBrowserWidget mainWidget
    ]

    buildClassBrowserWidget [
	<category: 'user interface'>

	^ browserWidget := (GtkClassBrowserWidget new)
			    initialize;
			    yourself
    ]

    createEditMenus [
	<category: 'user interface'>

        self accelGroup append: {{'<Control>Z'. '<GtkBrowser>/Edit/Undo'. self. #undo}.
            {'<Control>R'. '<GtkClassBrowser>/Edit/Redo'. self. #redo}.
            {'<Control>X'. '<GtkClassBrowser>/Edit/Cut'. self. #cut}.
            {'<Control>C'. '<GtkClassBrowser>/Edit/Copy'. self. #copy}.
            {'<Control>V'. '<GtkClassBrowser>/Edit/Paste'. self. #paste}.
            {'<Control>A'. '<GtkClassBrowser>/Edit/SelectAll'. self. #selectAll}}.

	^ self createMenuEntry: {#('Undo' #undo '').
	    #('Redo' #redo '').
	    #().
	    #('Cut' #cut '').
	    #('Copy' #copy '').
	    #('Paste' #paste '').
	    #().
	    #('Select all' #selectAll '')}.
    ]

    createSmalltalkMenus [
        <category: 'user interface'>

        self accelGroup append: {{'<Control>D'. '<GtkClassBrowser>/Smalltalk/DoIt'. self. #doIt}.
            {'<Control>P'. '<GtkClassBrowser>/Smalltalk/PrintIt'. self. #printIt}.
            {'<Control>I'. '<GtkClassBrowser>/Smalltalk/InspectIt'. self. #inspectIt}.
            {'<Control>M'. '<GtkClassBrowser>/Smalltalk/Implementors'. self. #implementors}.
            {'<Control>N'. '<GtkClassBrowser>/Smalltalk/Senders'. self. #senders}.
	    {'<Control>S'. '<GtkClassBrowser>/Smalltalk/AcceptIt'. self. #acceptIt}}.

        ^ self createMenuEntry: {#('Do It' #doIt '').
        #('Print It' #printIt '').
        #('Inspect It' #inspectIt '').
        #('Debug It' #debugIt '').
	#().
	#('Accept-It' #acceptIt '<GtkClassBrowser>/Smalltalk/AcceptIt')}
    ]

    createFileMenus [
	<category: 'user interface'>

        self accelGroup append: {{'<Control>N'. '<GtkClassBrowser>/File/New'. self. #newWorkspace}.
            {'<Control>O'. '<GtkClassBrowser>/File/Open'. self. #open}.
            {'<Control>S'. '<GtkClassBrowser>/File/Save'. self. #save}.
            {'<Control><Shift>S'. '<GtkClassBrowser>/File/SaveAs'. self. #saveAs}.
            {'<Control>Q'. '<GtkClassBrowser>/File/Quit'. self. #quit}}.

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

    createNamespaceMenus [
	<category: 'user interface'>

	^ self createMenuEntry: {#('Add a namespace' #newNamespace '').
	    #('Rename a namespace' #renameNamespace '').
	    #('Delete a namespace' #deleteNamespace '').
	    #().
	    #('Inspect a namespace' #inspectNamespace '').
	    #().
	    #('File out a namespace' #fileoutNamespace '').
	    #('File out in a project' #fileoutProject '')}
    ]

    createClassMenus [
	<category: 'user interface'>

	^ self createMenuEntry: {#('Add a class' #newClass '').
	    #('Rename a class' #renameClass '').
	    #('Delete a class' #deleteClass '').
	    #().
	    #('Inspect a class' #inspectClass '').
	    #().
	    #('File out a class' #fileoutClass '').
	    #('File out in a project' #fileoutClassInProject '')}
    ]

    createCategoryMenus [
	<category: 'user interface'>

	^ self createMenuEntry: {#('Add a category' #newCategory '').
            #('Rename a category' #renameCategory '').
            #('Delete a category' #deleteCategory '').
            #().
            #('Inspect a category' #inspectCategory '').
	    #().
            #('File out a category' #fileoutCategory '')}
    ]

    createMethodMenus [
	<category: 'user interface'>

	^ self createMenuEntry: {#('Add a method' #newMethod '').
	    #('Rename a method' #renameMethod '').
	    #('Delete a method' #deleteMethod '').
	    #().
	    #('Inspect a method' #inspectMethod '').
	    #().
	    #('File out a method' #fileoutMethod '')}
    ]

    createHelpMenus [
	<category: 'user interface'>

	^ self createMenuEntry: {#('About Class Browser' #aboutBrowser '').
	    #('About GNU Smalltalk' #aboutGst '')}
    ]

    createMenus [
	<category: 'user interface'>

	self addMenuItem: 'File' withSubmenu: self createFileMenus.
	self addMenuItem: 'Edit' withSubmenu: self createEditMenus.
	self addMenuItem: 'Namespace' withSubmenu: self createNamespaceMenus.
	self addMenuItem: 'Class' withSubmenu: self createClassMenus.
	self addMenuItem: 'Category' withSubmenu: self createCategoryMenus.
	self addMenuItem: 'Method' withSubmenu: self createMethodMenus.
	self addMenuItem: 'Smalltalk' withSubmenu: self createSmalltalkMenus.
	self addMenuItem: 'Tools' withSubmenu: self createToolsMenus.
	"self addMenuItem: 'Windows' withSubmenu: self createWindowsMenus."
	self addMenuItem: 'Help' withSubmenu: self createHelpMenus
    ]

    createStatusBar [
	<category: 'user interface'>

	self statusMessage: 'Gtk Browser'
    ]

    createToolbar [
	<category: 'user interface'>

	| temp |
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
	    appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-undo');
	    appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-redo');
	    appendSeparator;
	    appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-execute');
	    appendSeparator.
	    temp := (GTK.GtkToolItem new)
			add: ((GTK.GtkEntry new)
				setCompletion: ((GTK.GtkEntryCompletion new)
						    setModel: GtkImageModel currentModel;
						    setTextColumn: 0;
						    yourself);
				yourself);
			yourself.
	    self toolBar insert: temp pos: -1
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

    createWindowsMenus [
	<category: 'user interface'>

	^ self createMenuEntry: {#('Arrange' #arrangeWindows '').
	    #('Close all' #closeAllWindows '')}
    ]
]

