GtkMainWindow subclass: GtkLauncher [
    | currentWidget notebook notebookPages transcriptWidget windowsMenu |

    GtkLauncher class >> open [
	<category: 'user interface'>

	^ self openSized: 450@375
    ]

    aboutLauncher [
	<category: 'help events'>

	(GTK.GtkAboutDialog new)
	    setVersion: '0.2.0';
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
	    setWebsite: 'http://le site du gnu';
	    setComments: 'This is a GTK+ wrapper for GNU Smalltalk.';
	    "setAuthors: {'Gwenael Casaccio'. 'Nicolas Petton'. nil};"
	    setProgramName: 'GNU Smalltalk Launcher';
	    runBlockingAndDestroy
    ]

    aboutGst [
	<category: 'help events'>

        (GTK.GtkAboutDialog new)
            setVersion: '3.1.0';
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
            setWebsite: 'http://le site du gnu';
            setComments: 'This is a GTK+ wrapper for GNU Smalltalk.';
            "setAuthors: {'Paolo Bonzini'};"
            setProgramName: 'GNU Smalltalk';
            runBlockingAndDestroy
    ]

    browser [
	<category: 'events'>

	windowsMenu append: (GTK.GtkMenuItem label: 'Browser') showAll
    ]

    classBrowser [
	<category: 'events'>

	| widget |
	widget := self buildClassBrowserWidget showAll; yourself.
	notebookPages addLast: widget.
        notebook appendPage: widget mainWidget tabLabel: (self buildLabelWidget: 'Class Browser' withIcon: GTK.Gtk gtkStockClose at: widget)
    ]

    classBrowserInAWindow [
	<category: 'events'>

	GtkClassBrowser open
    ]

    gtkInspector [
	<category: 'events'>
	
	GtkInspector openOn: self
    ]

    newWorkspace [
	<category: 'events'>

	| widget |
	widget := self buildWorkspaceWidget showAll.
	notebookPages addLast: widget.
	notebook appendPage: widget mainWidget tabLabel: (self buildLabelWidget: 'Workspace' withIcon: GTK.Gtk gtkStockClose at: widget)
    ]

    quit [
	<category: 'file events'>

	GTK.Gtk mainQuit.
	ObjectMemory quit	
    ]

    open [
	<category: 'file events'>

	(GTK.GtkFileChooserDialog load: 'Load Smalltalk source' parent: window)
	    runNonBlockingAndDo: [ :dlg :res |
		res = GTK.Gtk gtkResponseAccept ifTrue: [ dlg getFilename ].
		dlg destroy ]
    ]

    save [
	<category: 'file events'>
    ]

    saveAs [
	<category: 'file events'>

        (GTK.GtkFileChooserDialog save: 'Save Smalltalk source as...' parent: window)
            runNonBlockingAndDo: [ :dlg :res |
                res = GTK.Gtk gtkResponseAccept ifTrue: [ dlg getFilename ].
                dlg destroy ]
    ]

    print [
	<category: 'file events'>
    ]

    saveImage [
        <category: 'events'>

        ObjectMemory snapshot
    ]

    saveImageAs [
	<category: 'events'>

	(GTK.GtkFileChooserDialog save: 'Save image as...' parent: window)
	    runNonBlockingAndDo: [ :dlg :res |
		res = GTK.Gtk gtkResponseAccept ifTrue: [ | name |
		    name := dlg getFilename.
		    ObjectMemory snapshot: name ].
		dlg destroy ]
    ]

    smallZilla [
	<category: 'events'>

	GtkSmallZilla open
    ]

    workspace [
	<category: 'events'>
	
	self newWorkspace.
	"workspaceWindows add: (GtkWorkspaceWidget new)
				initialize;
				mainWidget.
	windowsMenu append: (GtkMenuItem label: 'workspace') showAll"
    ]

    initialize [
	<category: 'initialization'>

	super initialize.
	notebookPages := OrderedCollection new.
	self
	    title: 'GNU Smalltalk Launcher';
	    createMenus;
	    createToolbar;
	    createStatusBar;
	    centralWidget: self buildCentralWidget
    ]

    buildCentralWidget [
	<category: 'intialize-release'>

	| workspaceWidget |
	notebook := GTK.GtkNotebook new
			connectSignal: 'switch-page' to: self selector: #switchPageOn:page:number: userData: nil.
	currentWidget := transcriptWidget := self buildTranscriptWidget.
	workspaceWidget := self buildWorkspaceWidget.
	notebookPages
	    addLast: transcriptWidget;
	    addLast: workspaceWidget.
	^ notebook 
	    appendPage: transcriptWidget mainWidget tabLabel: (self buildLabelWidget: 'Transcript' withIcon: GTK.Gtk gtkStockClose at: transcriptWidget);
            "setTabDetachable: transcriptWidget mainWidget detachable: true;
            setTabReorderable:  transcriptWidget mainWidget reorderable: true;"
	    appendPage: workspaceWidget mainWidget tabLabel: (self buildLabelWidget: 'Workspace' withIcon: GTK.Gtk gtkStockClose at: workspaceWidget);
	    "setTabDetachable: wkWidget detachable: true;
	    setTabReorderable:  wkWidget reorderable: true;"
	    setScrollable: true;
	    yourself
    ]

    buildLabelWidget: aString withIcon: aStockString at: aSmallInteger [
	<category: 'user interface'>
	
	| image close |
	image := GTK.GtkImage newFromStock: aStockString size: GTK.Gtk gtkIconSizeMenu.
	close := (GTK.GtkButton new)
		    setImage: image;
		    setRelief: GTK.Gtk gtkReliefNone;
		    connectSignal: 'pressed' to: self selector: #'closeIt:at:' userData: aSmallInteger;
		    yourself.
	^ (GTK.GtkHBox new: false spacing: 0)
	    add: (GTK.GtkLabel new: aString);
	    add: close;
	    showAll;
	    yourself
    ]

    buildClassBrowserWidget [
	<category: 'user interface'>

	^ (GtkClassBrowserWidget new)
	    initialize;
	    yourself
    ]

    buildTranscriptWidget [
	<category: 'user interface'>

	^ GtkTranscriptWidget new
	    initialize;
	    yourself
    ]

    buildWorkspaceWidget [
	<category: 'user interface'>

	^ GtkWorkspaceWidget new
	    initialize;
	    yourself
    ]

    createEditMenus [
	<category: 'user interface'>

	^ self createMenuEntry: {#('Undo' #undo).
	    #('Redo' #redo).
	    #().
	    #('Cut' #cut).
	    #('Copy' #copy).
	    #('Paste' #paste).
	    #().
	    #('Select all' #selectAll).
	    #().
	    #('Clear Transcript' #clearTranscriptWidget).
	    #().
	    #('Search' #searchClassOrMethod)}
    ]

    createFileMenus [
	<category: 'user interface'>

	^ self createMenuEntry: {#('New workspace' #newWorkspace).
	    #().
	    #('Open' #open).
	    #('Save' #save).
	    #('Save as...' #saveAs).
	    #().
	    #('Print' #print).
	    #().
	    #('Save image' #saveImage).
	    #('Save image as...' #saveImageAs).
	    #().
	    #('Quit' #quit)}
    ]

    createProjectMenus [
	<category: 'user interface'>

	^ self createMenuEntry: {#('New project' #newProject).
	    #().
	    #('Open project' #openProject).
	    #('Save project' #saveProject).
	    #('Save project as...' #saveProjectAs).
	    #().
	    #('Close project' #closeProject)}
    ]

    createSmalltalkMenus [
	<category: 'user interface'>

	^ self createMenuEntry: {#('Do It' #doIt).
	#('Print It' #printIt).
	#('Inspect It' #inspectIt).
	#('Debug It' #debugIt)}
    ]

    createHelpMenus [
	<category: 'user interface'>

	^ self createMenuEntry: {#('About Launcher' #aboutLauncher).
	    #('About GNU Smalltalk' #aboutGst)}
    ]

    createMenus [
	<category: 'user interface'>

	self createMainMenu: {#('File' #createFileMenus).
	    #('Edit' #createEditMenus).
	    #('Project' #createProjectMenus).
	    #('Smalltalk' #createSmalltalkMenus).
	    #('Tools' #createToolsMenus).
	    #('Windows' #createWindowsMenus).
	    #('Help' #createHelpMenus)}
    ]

    createStatusBar [
	<category: 'user interface'>

	self statusMessage: 'Gtk Launcher'
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
	    {#('Browser' #classBrowser).
	    #('Browser window' #classBrowserInAWindow).
	    #('Workspace' #workspace).
	    #('Inspector' #gtkInspector).
	    #().
	    #('Assistant' #gtkAssistant).
	    #().
	    #('GtkDemo' #gtkDemo).
	    #('SqueakZilla' #webBrowser)}
    ]

    createWindowsMenus [
	<category: 'user interface'>

	^ windowsMenu := self createMenuEntry: {#('Arrange' #arrangeWindows).
	    #('Close all' #closeAllWindows)}
    ]

    closeIt: aGtkButton  at: aGtkConcreteWidget [
	<category: 'notebook events'>
   
	| page |
	aGtkConcreteWidget = transcriptWidget ifTrue: [ self error: 'Can not remove the transcript tab' ].
	page := notebook pageNum: aGtkConcreteWidget mainWidget.
	notebookPages remove: aGtkConcreteWidget.
	notebook removePage: page
    ]

    switchPageOn: aGtkNotebook page: aGtkNotebookPage number: anInteger [
	<category: 'notebook events'>

	currentWidget := notebookPages at: anInteger + 1
    ]

    cut [
	<category: 'edit events'>

	currentWidget cut
    ]

    copy [
	<category: 'edit events'>

	currentWidget copy
    ]

    paste [
	<category: 'edit events'>

	currentWidget paste
    ]

    selectAll [
	<category: 'edit events'>

	currentWidget selectAll
    ]

    clearTranscriptWidget [
	<category: 'edit events'>

	transcriptWidget clear
    ]

    newProject [
	<category: 'project events'>

	| dlg project file |
	dlg := GtkProjectDialog open.
	dlg hasPressedOk ifFalse: [ ^ self ].
	project := dlg result.
	file := Directory userBase / (project name).
	file exists ifTrue: [ self error: 'Project already exist' ].
	file := FileStream open: file asString mode: FileStream write.
	(ObjectDumper on: file)
	    dump: project.
	file close.
    ]

    doIt [
	<category: 'smalltalk events'>

	currentWidget doIt
    ]

    printIt [
	<category: 'smalltalk events'>

	currentWidget printIt
    ]

    inspectIt [
	<category: 'smalltalk events'>

	currentWidget inspectIt
    ]

    debugIt [
	<category: 'smalltalk events'>

	currentWidget debugIt
    ]

    searchClassOrMethod [
	<category: 'edit events'>

	GtkFinder open
    ]

    gtkAssistant [
	<category: 'tools events'>

	GtkAssistant open
    ]

    webBrowser [
	<category: 'tools events'>

	GtkWebBrowser open
    ]
]

