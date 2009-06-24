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

    acceptIt [
	<categoyr: 'smalltalk events'>

	browserWidget acceptIt
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

	^ self createNewMenuEntry: {GTK.GtkMenuItem menuItem: 'Undo' accelPath: '<GtkBrowser>/Edit/Undo'.
	    GTK.GtkMenuItem menuItem: 'Redo' accelPath: '<GtkClassBrowser>/Edit/Redo'.
	    GTK.GtkMenuItem new.
	    GTK.GtkMenuItem menuItem: 'Cut' accelPath: '<GtkClassBrowser>/Edit/Cut'.
	    GTK.GtkMenuItem menuItem: 'Copy' accelPath: '<GtkClassBrowser>/Edit/Copy'.
	    GTK.GtkMenuItem menuItem: 'Paste' accelPath: '<GtkClassBrowser>/Edit/Paste'.
	    GTK.GtkMenuItem new.
	    GTK.GtkMenuItem menuItem: 'Select all' accelPath: '<GtkClassBrowser>/Edit/SelectAll'}.
    ]

    createSmalltalkMenus [
        <category: 'user interface'>

        self accelGroup append: {{'<Control>D'. '<GtkClassBrowser>/Smalltalk/DoIt'. self. #doIt}.
            {'<Control>P'. '<GtkClassBrowser>/Smalltalk/PrintIt'. self. #printIt}.
            {'<Control>I'. '<GtkClassBrowser>/Smalltalk/InspectIt'. self. #inspectIt}.
            {'<Control>M'. '<GtkClassBrowser>/Smalltalk/Implementors'. self. #implementors}.
            {'<Control>N'. '<GtkClassBrowser>/Smalltalk/Senders'. self. #senders}.
	    {'<Control>S'. '<GtkClassBrowser>/Smalltalk/AcceptIt'. self. #acceptIt}}.

        ^ self createNewMenuEntry: {GTK.GtkMenuItem menuItem: 'Do It' accelPath: '<GtkClassBrowser>/Smalltalk/DoIt'.
        GTK.GtkMenuItem menuItem: 'Print It' accelPath: '<GtkClassBrowser>/Smalltalk/PrintIt'.
        GTK.GtkMenuItem menuItem: 'Inspect It' accelPath: '<GtkClassBrowser>/Smalltalk/InspectIt'.
        GTK.GtkMenuItem menuItem: 'Debug It' connectTo: self selector: #debugIt.
	GTK.GtkMenuItem new.
	GTK.GtkMenuItem menuItem: 'Accept-It' accelPath: '<GtkClassBrowser>/Smalltalk/AcceptIt'}
    ]

    createFileMenus [
	<category: 'user interface'>

        self accelGroup append: {{'<Control>O'. '<GtkClassBrowser>/File/Open'. self. #open}.
            "{'<Control>S'. '<GtkClassBrowser>/File/Save'. self. #save}."
            {'<Control><Shift>S'. '<GtkClassBrowser>/File/SaveAs'. self. #saveAs}.
            {'<Control>Q'. '<GtkClassBrowser>/File/Quit'. self. #quit}}.

	^ self createNewMenuEntry: {GTK.GtkMenuItem menuItem: 'New workspace' connectTo: self selector: #newWorkspace.
	    GTK.GtkMenuItem new.
	    GTK.GtkMenuItem menuItem: 'Open' accelPath: '<GtkClassBrowser>/File/Open'.
	    GTK.GtkMenuItem menuItem: 'Save' connectTo: self selector: #save.
	    GTK.GtkMenuItem menuItem: 'Save as...' accelPath: '<GtkClassBrowser>/File/SaveAs'.
	    GTK.GtkMenuItem new.
	    GTK.GtkMenuItem menuItem: 'Print' connectTo: self selector: #print.
	    GTK.GtkMenuItem new.
	    GTK.GtkMenuItem menuItem: 'Save image' connectTo: self selector: #saveImage.
	    GTK.GtkMenuItem menuItem: 'Save image as...' connectTo: self selector: #saveImageAs.
	    GTK.GtkMenuItem new.
	    GTK.GtkMenuItem menuItem: 'Quit' accelPath: '<GtkClassBrowser>/File/Quit'}
    ]

    createNamespaceMenus [
	<category: 'user interface'>

	^ self createNewMenuEntry: {GTK.GtkMenuItem menuItem: 'Add a namespace' connectTo: self selector: #newNamespace.
	    GTK.GtkMenuItem menuItem: 'Rename a namespace' connectTo: self selector: #renameNamespace.
	    GTK.GtkMenuItem menuItem: 'Delete a namespace' connectTo: self selector: #deleteNamespace.
	    GTK.GtkMenuItem new.
	    GTK.GtkMenuItem menuItem: 'Inspect a namespace' connectTo: self selector: #inspectNamespace.
	    GTK.GtkMenuItem new.
	    GTK.GtkMenuItem menuItem: 'File out a namespace' connectTo: self selector: #fileoutNamespace.
	    GTK.GtkMenuItem menuItem: 'File out in a project' connectTo: self selector: #fileoutProject}
    ]

    createClassMenus [
	<category: 'user interface'>

	^ self createNewMenuEntry: {GTK.GtkMenuItem menuItem: 'Add a class' connectTo: self selector: #newClass.
	    GTK.GtkMenuItem menuItem: 'Rename a class' connectTo: self selector: #renameClass.
	    GTK.GtkMenuItem menuItem: 'Delete a class' connectTo: self selector: #deleteClass.
	    GTK.GtkMenuItem new.
	    GTK.GtkMenuItem menuItem: 'Inspect a class' connectTo: self selector: #inspectClass.
	    GTK.GtkMenuItem new.
	    GTK.GtkMenuItem menuItem: 'File out a class' connectTo: self selector: #fileoutClass.
	    GTK.GtkMenuItem menuItem: 'File out in a project' connectTo: self selector: #fileoutClassInProject}
    ]

    createCategoryMenus [
	<category: 'user interface'>

	^ self createNewMenuEntry: {GTK.GtkMenuItem menuItem: 'Add a category' connectTo: self selector: #newCategory.
            GTK.GtkMenuItem menuItem: 'Rename a category' connectTo: self selector: #renameCategory.
            GTK.GtkMenuItem menuItem: 'Delete a category' connectTo: self selector: #deleteCategory.
            GTK.GtkMenuItem new.
            GTK.GtkMenuItem menuItem: 'Inspect a category' connectTo: self selector: #inspectCategory.
	    GTK.GtkMenuItem new.
            GTK.GtkMenuItem menuItem: 'File out a category' connectTo: self selector: #fileoutCategory}
    ]

    createMethodMenus [
	<category: 'user interface'>

	^ self createNewMenuEntry: {GTK.GtkMenuItem menuItem: 'Add a method' connectTo: self selector: #newMethod.
	    GTK.GtkMenuItem menuItem: 'Rename a method' connectTo: self selector: #renameMethod.
	    GTK.GtkMenuItem menuItem: 'Delete a method' connectTo: self selector: #deleteMethod.
	    GTK.GtkMenuItem new.
	    GTK.GtkMenuItem menuItem: 'Inspect a method' connectTo: self selector: #inspectMethod.
	    GTK.GtkMenuItem new.
	    GTK.GtkMenuItem menuItem: 'File out a method' connectTo: self selector: #fileoutMethod}
    ]

    createHelpMenus [
	<category: 'user interface'>

	^ self createNewMenuEntry: {GTK.GtkMenuItem menuItem: 'About Class Browser' connectTo: self selector: #aboutBrowser.
	    GTK.GtkMenuItem menuItem: 'About GNU Smalltalk' connectTo: self selector: #aboutGst}
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

	^ self createNewMenuEntry: 
	    {GTK.GtkMenuItem menuItem: 'Browser' connectTo: self selector: #classBrowser.
	    GTK.GtkMenuItem menuItem: 'Workspace' connectTo: self selector: #workspace.
	    GTK.GtkMenuItem menuItem: 'Inspector' connectTo: self selector: #gtkInspector.
	    GTK.GtkMenuItem new.
	    GTK.GtkMenuItem menuItem: 'SqueakZilla' connectTo: self selector: #squeakzilla}
    ]

    createWindowsMenus [
	<category: 'user interface'>

	^ self createNewMenuEntry: {GTK.GtkMenuItem menuItem: 'Arrange' connectTo: self selector: #arrangeWindows.
	    GTK.GtkMenuItem menuItem: 'Close all' connectTo: self selector: #closeAllWindows}
    ]
]

