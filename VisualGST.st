GtkMainWindow subclass: VisualGST [
    | currentWidget notebook notebookPages transcriptWidget windowsMenu |

    VisualGST class >> open [
	<category: 'user interface'>

	^ self openSized: 450@375
    ]

    VisualGST class >> version [
	<category: 'accessing'>

	^ '0.4.0'
    ]

    VisualGST class >> website [
	<category: 'accessing'>

	^ 'http://visualgst.bioskop.fr/'
    ]
    
    VisualGST class >> gstWebsite [
	<category: 'accessing'>

	^ 'http://smalltalk.gnu.org/'
    ]

    aboutLauncher [
	<category: 'help events'>

	(GTK.GtkAboutDialog new)
	    setVersion: self class version;
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
	    setWebsite: self class website;
	    setComments: 'This is a GTK+ wrapper for GNU Smalltalk.';
	    "setAuthors: {'Gwenael Casaccio'. 'Nicolas Petton'. nil};"
	    setProgramName: 'VisualGST';
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

	| file string |
	currentWidget == transcriptWidget ifTrue: [ self error: 'Can not remove the transcript tab' ].
	(GTK.GtkFileChooserDialog load: 'Load Smalltalk source' parent: window)
	    runNonBlockingAndDo: [ :dlg :res |
		res = GTK.Gtk gtkResponseAccept ifFalse: [ ^ dlg destroy ].
		file := FileStream open: dlg getFilename mode: FileStream read.
		currentWidget text: file upToEnd.
		dlg destroy ]
    ]

    save [
	<category: 'file events'>
    ]

    saveAs [
	<category: 'file events'>

	| file |
        (GTK.GtkFileChooserDialog save: 'Save Smalltalk source as...' parent: window)
            runNonBlockingAndDo: [ :dlg :res |
                res = GTK.Gtk gtkResponseAccept ifFalse: [ ^ dlg destroy ].
		file := FileStream open: dlg getFilename mode: FileStream write.
		file nextPutAll: currentWidget text. 
                dlg destroy ]
    ]

    print [
	<category: 'file events'>
    ]

    saveImage [
        <category: 'events'>

        (GTK.GtkMessageDialog new: window flags: GTK.Gtk gtkDialogDestroyWithParent type: GTK.Gtk gtkMessageWarning buttons: GTK.Gtk gtkButtonsOk message: 'WARNING : You can loose all the data')
            runBlockingAndDestroy.
        ObjectMemory snapshot
    ]

    saveImageAs [
	<category: 'events'>

	(GTK.GtkMessageDialog new: window flags: GTK.Gtk gtkDialogDestroyWithParent type: GTK.Gtk gtkMessageWarning buttons: GTK.Gtk gtkButtonsOk message: 'WARNING : You can loose all the data')
	    runBlockingAndDestroy.
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

    clearGlobalState [
	<category: 'initialization cleanup'>

	GtkNamespaceModel instVarNamed: #current put: nil.
	GtkClassModel instVarNamed: #current put: nil.
	GtkCategoryModel instVarNamed: #current put: nil.
	GtkMethodModel instVarNamed: #current put: nil.
	GtkImageModel instVarNamed: #current put: nil.
    ]

    initialize [
	<category: 'initialization'>

	super initialize.
	notebookPages := OrderedCollection new.
	self
	    clearGlobalState;
	    title: 'VisualGST';
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

	self accelGroup append: {{'<Control>Z'. '<GtkLauncher>/Edit/Undo'. self. #undo}.
	    {'<Control>R'. '<GtkLauncher>/Edit/Redo'. self. #redo}.
	    {'<Control>X'. '<GtkLauncher>/Edit/Cut'. self. #cut}.
	    {'<Control>C'. '<GtkLauncher>/Edit/Copy'. self. #copy}.
	    {'<Control>V'. '<GtkLauncher>/Edit/Paste'. self. #paste}.
	    {'<Control>A'. '<GtkLauncher>/Edit/SelectAll'. self. #selectAll}}.

	^ self createNewMenuEntry: {GTK.GtkMenuItem menuItem: 'Undo' accelPath: '<GtkLauncher>/Edit/Undo'.
            GTK.GtkMenuItem menuItem: 'Redo' accelPath: '<GtkLauncher>/Edit/Redo'.
            GTK.GtkMenuItem new.
            GTK.GtkMenuItem menuItem: 'Cut' accelPath: '<GtkLauncher>/Edit/Cut'.
            GTK.GtkMenuItem menuItem: 'Copy' accelPath: '<GtkLauncher>/Edit/Copy'.
            GTK.GtkMenuItem menuItem: 'Paste' accelPath: '<GtkLauncher>/Edit/Paste'.
            GTK.GtkMenuItem new.
            GTK.GtkMenuItem menuItem: 'Select all' accelPath: '<GtkLauncher>/Edit/SelectAll'.
            GTK.GtkMenuItem new.
            GTK.GtkMenuItem menuItem: 'Clear Transcript' accelPath: '<GtkLauncher>/Edit/ClearTranscript'}
    ]

    createFileMenus [
	<category: 'user interface'>

        self accelGroup append: 
	    {{'<Control>O'. '<GtkLauncher>/File/Open'. self. #open}.
	    {'<Control>S'. '<GtkLauncher>/File/Save'. self. #save}.
	    {'<Control><Shift>S'. '<GtkLauncher>/File/SaveAs'. self. #saveAs}.
	    {'<Control>Q'. '<GtkLauncher>/File/Quit'. self. #quit}}.

	^ self createNewMenuEntry: {GTK.GtkMenuItem menuItem: 'New worskpace' connectTo: self selector: #newWorkspace.
            GTK.GtkMenuItem new.
	    GTK.GtkMenuItem menuItem: 'Open' accelPath: '<GtkLauncher>/File/Open'.
            GTK.GtkMenuItem menuItem: 'Save' accelPath: '<GtkLauncher>/File/Save'.
            GTK.GtkMenuItem menuItem: 'Save as...' accelPath: '<GtkLauncher>/File/SaveAs'.
            GTK.GtkMenuItem new.
            GTK.GtkMenuItem menuItem: 'Print' connectTo: self selector: #printIt.
            GTK.GtkMenuItem new.
            GTK.GtkMenuItem menuItem: 'Save image' connectTo: self selector: #saveImage.
            GTK.GtkMenuItem menuItem: 'Save image as...' connectTo: self selector: #saveImageAs.
            GTK.GtkMenuItem new.
            GTK.GtkMenuItem menuItem: 'Quit' accelPath: '<GtkLauncher>/File/Quit'}
    ]

    createProjectMenus [
	<category: 'user interface'>

        ^ self createNewMenuEntry: {GTK.GtkMenuItem menuItem: 'New project' connectTo: self selector: #newProject.
            GTK.GtkMenuItem new.
            GTK.GtkMenuItem menuItem: 'Open project' connectTo: self selector: #openProject.
            GTK.GtkMenuItem menuItem: 'Save project' connectTo: self selector: #saveProject.
            GTK.GtkMenuItem menuItem: 'Save project as...' connectTo: self selector: #saveProjectAs.
            GTK.GtkMenuItem new.
            GTK.GtkMenuItem menuItem: 'Close project' connectTo: self selector: #closeProject}
    ]

    createSmalltalkMenus [
	<category: 'user interface'>

        self accelGroup append: {{'<Control>D'. '<GtkLauncher>/Smalltalk/DoIt'. self. #doIt}.
            {'<Control>P'. '<GtkLauncher>/Smalltalk/PrintIt'. self. #printIt}.
            {'<Control>I'. '<GtkLauncher>/Smalltalk/InspectIt'. self. #inspectIt}.
            {'<Control>M'. '<GtkLauncher>/Smalltalk/Implementors'. self. #implementors}.
            {'<Control>N'. '<GtkLauncher>/Smalltalk/Senders'. self. #senders}}.

        ^ self createNewMenuEntry: {GTK.GtkMenuItem menuItem: 'Do It' accelPath: '<GtkLauncher>/Smalltalk/DoIt'.
            GTK.GtkMenuItem menuItem: 'Print It' accelPath: '<GtkLauncher>/Smalltalk/PrintIt'.
            GTK.GtkMenuItem menuItem: 'Inspect It' accelPath: '<GtkLauncher>/Smalltalk/InspectIt'.
            GTK.GtkMenuItem menuItem: 'Debug It' connectTo: self selector: #debugIt.
            GTK.GtkMenuItem new.
            GTK.GtkMenuItem menuItem: 'Implementors' accelPath: '<GtkLauncher>/Smalltalk/Implementors'.
            GTK.GtkMenuItem menuItem: 'Senders' accelPath: '<GtkLauncher>/Smalltalk/Senders'}
    ]

    createHelpMenus [
	<category: 'user interface'>

	^ self createNewMenuEntry: {GTK.GtkMenuItem menuItem: 'About Launcher' connectTo: self selector: #aboutLauncher.
	    GTK.GtkMenuItem menuItem: 'About GNU Smalltalk' connectTo: self selector: #aboutGst}
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
        self accelGroup append: {{'<Control>B'. '<GtkLauncher>/Tools/ClassBrowser'. self. #classBrowserInAWindow}}.

	^ self createNewMenuEntry:  {GTK.GtkMenuItem menuItem: 'Browser' connectTo: self selector: #classBrowser.
	    GTK.GtkMenuItem menuItem: 'Browser window' accelPath: '<GtkLauncher>/Tools/ClassBrowser' connectTo: self selector: #classBrowserInAWindow.
	    GTK.GtkMenuItem menuItem: 'Workspace' connectTo: self selector: #workspace.
	    GTK.GtkMenuItem menuItem: 'Inspector' connectTo: self selector: #gtkInspector.
	    GTK.GtkMenuItem new.
	    GTK.GtkMenuItem menuItem: 'Assistant' connectTo: self selector: #gtkAssistant.
	    GTK.GtkMenuItem new.
	    GTK.GtkMenuItem menuItem: 'GtkDemo' connectTo: self selector: #gtkDemo.
	    GTK.GtkMenuItem menuItem: 'SqueakZilla' connectTo: self selector: #webBrowser}
    ]

    createWindowsMenus [
	<category: 'user interface'>

	^ windowsMenu := self createNewMenuEntry: {GTK.GtkMenuItem menuItem: 'Arrange' connectTo: self selector: #arrangeWindows .
	    GTK.GtkMenuItem menuItem: 'Close all' connectTo: self selector: #closeAllWindows}
    ]

    isCurrentWidgetTranscript [
	<category: 'testing'>

	^ currentWidget == transcriptWidget
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

    undo [
	<category: 'edit events'>

	self isCurrentWidgetTranscript ifTrue: [ ^ self ].
	currentWidget undo
    ]

    redo [
	<category: 'edit events'>

	currentWidget redo
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

    implementors [
	<category: 'smalltalk events'>

	GtkImplementor open
    ]

    senders [
	<category: 'smalltalk events'>

	GtkSender open
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

