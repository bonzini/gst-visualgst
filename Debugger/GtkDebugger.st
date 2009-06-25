GtkMainWindow subclass: GtkDebugger [
    | windowsMenu |

    GtkDebugger class >> open [
	<category: 'user interface'>

	^ self openSized: 450@375
    ]

    aboutDebugger [
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

    initialize [
	<category: 'initialization'>

	super initialize.
	self
	    title: 'VisualGST Debugger';
	    createMenus;
	    createToolbar;
	    createStatusBar;
	    centralWidget: self buildCentralWidget
    ]
    
    buildContextWidget [
	<category: 'user interface'>

	^ GtkContextWidget new mainWidget
    ]

    buildSourceAndInspectorWidget [
	<category: 'user interface'>

	^ GtkContextWidget new mainWidget
    ]

    buildCentralWidget [
	<category: 'intialize-release'>

	^ (GtkVPaned new)
	    pack1: self buildContextWidget resize: true shrink: false;
	    pack2: self buildSourceAndInspectorWidget resize: true shrink: true;
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
	    GTK.GtkMenuItem menuItem: 'Browser window' accelPath: '<GtkLauncher>/Tools/ClassBrowser'.
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
]

