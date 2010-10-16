GtkVisualGSTTool subclass: GtkShell [
    | leftSidebar rightSidebar topSidebar packageBuilderWidget implementorResultWidget senderResultWidget senderWidget implementorWidget historyWidget browsers saved undoStack |

    GtkShell class >> open [
	<category: 'user interface'>

        "TODO: add #openOn:"
        ^self new open
    ]

    open [
        <category: 'private'>

        ^ self
            initialize;
            showAll;
            postInitialize;
	    resize: 1024@600;
            yourself
    ]

    exit [
	<category: 'exit'>

	GTK.Gtk mainQuit.
	ObjectMemory quit	
    ]

    accelPath [
	<category: 'accelerator path'>

	^ '<GtkShell>'
    ]

    sunitBrowser [
	<category: 'tools events'>

	| widget |
	browsers addWidget: (widget := self buildSUnitBrowserWidget) labeled: 'SUnit'.
        browsers showLastPage.
	widget postInitialize.
	^ widget
    ]

    classBrowser [
	<category: 'tools events'>

	| widget |
	browsers addWidget: (widget := self buildClassBrowserWidget) labeled: 'Browser'.
        browsers showLastPage.
	widget postInitialize.
	^ widget
    ]

    newWorkspace [
	<category: 'tools events'>

        ^self newWorkspaceLabeled: 'Workspace'
    ]

    newWorkspaceLabeled: aString [
	<category: 'tools events'>

	| widget |
	widget := self buildWorkspaceWidget showAll.
	widget postInitialize.
	browsers addWidget: widget labeled: aString.
        browsers showLastPage.
        ^widget
    ]

    onDelete: aGtkWidget event: aGdkEvent [
	<category: 'window events'>

	self quit.
	^ true 
    ]

    quit [
	<category: 'file events'>

        GtkLauncher uniqueInstance quit
    ]

    openFile [
	<category: 'file events'>

	| file string |
	(GTK.GtkFileChooserDialog load: 'Load Smalltalk source' parent: window)
	    showModalOnAnswer: [ :dlg :res |
		res = GTK.Gtk gtkResponseAccept 
				ifTrue: [ file := File name: dlg getFilename.
                                          FileStream open: dlg getFilename mode: FileStream read.
					  (self newWorkspaceLabeled: file stripPath) text: file contents ].
		dlg destroy ]
    ]

    save [
	<category: 'file events'>
    ]

    saveAs [
	<category: 'file events'>

	| file |
        (GTK.GtkFileChooserDialog save: 'Save Smalltalk source as...' parent: window)
            showModalOnAnswer: [ :dlg :res |
                res = GTK.Gtk gtkResponseAccept 
				ifTrue: [ file := FileStream open: dlg getFilename mode: FileStream write.
					  file nextPutAll: browsers currentWidget text ].
		dlg destroy ]
    ]

    print [
	<category: 'file events'>
    ]

    saveImageAndQuit [
        <category: 'file events'>

        GtkLauncher uniqueInstance saveImageAndQuit
    ]

    saveImage [
        <category: 'file events'>

        GtkLauncher uniqueInstance saveImage
    ]

    saveImageAs [
	<category: 'file events'>

        GtkLauncher uniqueInstance saveImageAs
    ]

    saveImageAsAndQuit [
        <category: 'file events'>

        GtkLauncher uniqueInstance saveImageAsAndQuit
    ]

    saveImage: aBlock [
        <category: 'file events'>

        GtkLauncher uniqueInstance saveImage: aBlock
    ]

    clearGlobalState [
	<category: 'initialization cleanup'>

    ]

    initialize [
	<category: 'initialization'>

	saved := false.
	undoStack := UndoStack new.
	self clearGlobalState.
	super initialize.
	window setIcon: (GTK.GdkPixbuf newFromFile: (GtkLauncher / 'Icons/visualgst.png') file displayString error: nil)
    ]

    windowTitle [
        <category: 'widget'>

        ^ 'VisualGST'
    ]

    browserPostInitialize [
	<category: 'initialization'>

        browsers grabFocus.
        browsers currentWidget postInitialize.
    ]

    postInitialize [
	<category: 'initialization'>

	super postInitialize.
        self browserPostInitialize.
	leftSidebar postInitialize.
	topSidebar postInitialize.
	rightSidebar postInitialize.
	window
	    connectSignal: 'key-press-event' to: self selector:  #'keyPressedOn:keyEvent:'
    ]

    buildImplementorPaned [
       <category: 'user interface'>

	leftSidebar := GtkHSidebarWidget new
			    initialize;
			    addAll: {self buildImplementorView -> 'Implementor'. self buildSenderView -> 'Sender'. self buildHistoryView -> 'History'};
			    yourself.
	^ leftSidebar mainWidget
    ]

    buildPackageBuilderView [
	<category: 'user interface'>

	packageBuilderWidget := GtkPackageBuilderWidget new
						    initialize;
						    yourself.
	^ packageBuilderWidget mainWidget
    ]

    buildRightSidebarPaned [
       <category: 'user interface'>

        rightSidebar := GtkHSidebarWidget new
                            initialize;
                            addAll: {self buildPackageBuilderView -> 'Package Builder'};
                            yourself.
        ^ rightSidebar mainWidget
    ]

    buildCentralWidget [
        <category: 'intialize-release'>

        ^ GTK.GtkHPaned addAll: {self buildImplementorPaned. self buildCentralPaned. self buildRightSidebarPaned}. 
    ]

    buildImplementorView [
       <category: 'user interface'>

        implementorWidget := self buildImageView
			    whenSelectionChangedSend: #implementorSelected to: self;
			    yourself.
        ^ implementorWidget mainWidget
    ]

    buildSenderView [
       <category: 'user interface'>

        senderWidget := self buildImageView
			    whenSelectionChangedSend: #senderSelected to: self;
			    yourself.
        ^ senderWidget mainWidget
    ]

    buildImageView [
       <category: 'user interface'>

        ^ GtkImageWidget new
			initialize;
                        yourself
    ]

    buildHistoryView [
       <category: 'user interface'>

        historyWidget := GtkHistoryWidget new
                                    shell: self;
                                    yourself.
        ^ historyWidget mainWidget
    ]

    buildImplementorResultList [
        <category: 'user interface'>

        ^ implementorResultWidget := GtkImplementorResultsWidget new
					    initialize;
					    whenSelectionChangedSend: #resultImplementorSelected to: self;
					    yourself
    ]

    buildSenderResultList [
        <category: 'user interface'>

        ^ senderResultWidget := GtkSenderResultsWidget new
					    initialize;
					    whenSelectionChangedSend: #resultSenderSelected to: self;
					    yourself
    ]

    buildTopSidebar [
        <category: 'user interface'>

        topSidebar := GtkHSidebarWidget new
                            initialize;
                            addAll: {self buildImplementorResultList mainWidget -> ''. self buildSenderResultList mainWidget -> ''};
			    hideTabs;
                            yourself.
        ^ topSidebar mainWidget
    ]

    buildCentralPaned [
        <category: 'user interface'>

	^ GTK.GtkVPaned addAll: {self buildTopSidebar. self buildTabAreaWidget mainWidget}
    ]

    buildTabAreaWidget [
	<category: 'user interface'>

	(browsers := GtkNotebookWidget parentWindow: window)
				    showAll;
                                    whenSelectionChangedSend: #historyChanged to: self.

        self buildInitialTabs.
        ^browsers showLastPage; yourself
    ]

    buildInitialTabs [
	<category: 'user interface'>

	browsers addWidget: self buildClassBrowserWidget labeled: 'Browser'
    ]

    buildSUnitBrowserWidget [
	<category: 'user interface'>

	^ (GtkSUnitTab parentWindow: window)
             shell: self;
             yourself
    ]

    buildClassBrowserWidget [
	<category: 'user interface'>

	^ (GtkClassBrowserWidget parentWindow: window)
             shell: self;
             yourself
    ]

    buildWorkspaceWidget [
	<category: 'user interface'>

	^ GtkWorkspaceTab parentWindow: window
    ]

    createNamespaceMenus [
        <category: 'user interface'>

	^ NamespaceMenus browserBuildOn: self
    ]

    createClassMenus [
        <category: 'user interface'>

	^ ClassMenus browserBuildOn: self
    ]

    createCategoryMenus [
        <category: 'user interface'>

	^ CategoryMenus browserBuildOn: self
    ]

    createMethodMenus [
        <category: 'user interface'>

	^ MethodMenus browserBuildOn: self
    ]

    createFileMenus [
	<category: 'user interface'>

        self accelGroup append: 
	    {{'<Control>O'. '<GtkLauncher>/File/Open'}.
	    {'<Control><Shift>S'. '<GtkLauncher>/File/SaveAs'}.
	    {'<Control>Q'. '<GtkLauncher>/File/Quit'}}.

	^{	    GTK.GtkMenuItem menuItem: 'Open' accelPath: '<GtkLauncher>/File/Open' connectTo: self selector: #open.
            GTK.GtkMenuItem menuItem: 'Save' connectTo: self selector: #save.
            GTK.GtkMenuItem menuItem: 'Save as...' accelPath: '<GtkLauncher>/File/SaveAs' connectTo: self selector: #saveAs.
            GTK.GtkMenuItem new}, super createFileMenus
    ]

    createHistoryMenus [
	<category: 'user interface'>

	^ HistoryMenus browserBuildOn: self
    ]

    createTabsMenus [
	<category: 'user interface'>

	^ TabsMenus browserBuildOn: self
    ]

    createToolbar [
	<category: 'user interface'>

	self
	    appendToolItem: ((GTK.GtkToolButton newFromStock: 'gtk-new')
				connectSignal: 'clicked' to: self selector: #newWorkspace;
				setTooltipText: 'Create a new workspace';
				yourself).
        super createToolbar
    ]

    createMenus [
	<category: 'user interface'>

	self createMainMenu: {#('File' #createFileMenus).
	    #('Edit' #createEditMenus).
	    #('History' #createHistoryMenus).
	    #('Namespace' #createNamespaceMenus).
	    #('Class' #createClassMenus).
	    #('Category' #createCategoryMenus).
	    #('Method' #createMethodMenus).
	    #('Smalltalk' #createSmalltalkMenus).
	    #('Tools' #createToolsMenus).
	    #('Tabs' #createTabsMenus).
	    #('Help' #createHelpMenus)}
    ]

    createToolsMenus [
	<category: 'user interface'>

	^ ToolsMenus browserBuildOn: self
    ]

    shell [
	<category: 'accessing'>

	^self
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

    find [
	<category: 'edit events'>

	self onFocusPerform: #showFind
    ]

    replace [
	<category: 'edit events'>

	self onFocusPerform: #showReplace
    ]

    focusedWidget [
	<category: 'focus'>

	^browsers focusedWidget
    ]

    browserHasFocus [
	<category: 'testing'>

	^ browsers hasFocus
    ]

    sourceCodeWidgetHasFocus [
	<category: 'focus'>

	^ browsers currentWidget sourceCodeWidgetHasFocus
    ]

    state [
	<category: 'focus'>

	browsers currentWidget ifNil: [ ^ BrowserState new ].
	^ browsers currentWidget state
    ]

    selectedText [
	<category: 'smalltalk events'>

	^ self onFocusPerform: #selectedText
    ]

    selectedMethodSymbol [
        <category: 'text editing'>

        ^ self onFocusPerform: #selectedMethodSymbol
    ]

    hasSelection [
	<category: 'smalltalk events'>

        | widget |
	widget := self focusedWidget.
	^ widget notNil and: [widget hasSelection]
    ]

    targetObject [
	<category: 'smalltalk events'>

	^ self onFocusPerform: #targetObject
    ]

    doIt: anObject [
	<category: 'smalltalk events'>

	self onFocusPerform: #doIt: with: anObject
    ]

    printIt: anObject [
	<category: 'smalltalk events'>

	self onFocusPerform: #printIt: with: anObject
    ]

    inspectIt: anObject [
	<category: 'smalltalk events'>

	self onFocusPerform: #inspectIt: with: anObject
    ]

    debugIt: anObject [
	<category: 'smalltalk events'>

	self onFocusPerform: #debugIt: with: anObject
    ]

    acceptIt [
	<category: 'smalltalk events'>

	browsers currentWidget acceptIt
    ]

    showImplementorOn: aSymbol [
        <category: 'image events'>

	(self showHideWithSelectorOn: implementorWidget at: 1)
	    ifTrue: [ self imageSelectorForImplementor: aSymbol ]
    ]

    showHideImplementor [
        <category: 'image events'>

	self showHideOn: implementorWidget at: 1
    ]

    showSenderOn: aSymbol [
        <category: 'image events'>

	(self showHideWithSelectorOn: senderWidget at: 2)
	    ifTrue: [ self imageSelectorForSender: aSymbol ]
    ]

    showHideSender [
        <category: 'image events'>

	self showHideOn: senderWidget at: 2
    ]

    hideSidebars [

        leftSidebar hide.
        topSidebar hide.
        rightSidebar hide.
    ]

    showHideOn: aGtkWidget at: anIndex [

        | isVisible |
        isVisible := aGtkWidget isVisible.
	self hideSidebars.
        isVisible
            ifFalse: [
                topSidebar show: anIndex.
                leftSidebar show: anIndex ]
    ]

    showHideWithSelectorOn: aGtkWidget at: anIndex [
        <category: 'image events'>

        | isVisible |
        isVisible := aGtkWidget isVisible.
	self hideSidebars.
        isVisible ifTrue: [ ^ false ].
        leftSidebar show: anIndex.
        topSidebar show: anIndex.
	^ true
    ]

    showHidePackageBuilder [
        <category: 'image events'>

        | isVisible |
        isVisible := packageBuilderWidget isVisible.
	self hideSidebars.
        isVisible
            ifFalse: [
                rightSidebar show: 1 ]
    ]

    codeSaved [
	<category: 'browser forward'>

	browsers currentWidget codeSaved
    ]

    clearUndo [
	<category: 'browser forward'>

	browsers currentWidget clearUndo
    ]

    sourceCode [
	<category: 'browser forward'>

	^browsers currentWidget sourceCode
    ]

    updateState: aState [
	<category: 'browser forward'>

	browsers currentWidget updateState: aState
    ]

    back [
	<category: 'history events'>

	browsers currentWidget back
    ]

    forward [
	<category: 'history events'>

	browsers currentWidget forward
    ]

    showHideHistory [
	<category: 'history events'>

	| isVisible |
        isVisible := historyWidget isVisible.
	leftSidebar hide.
	topSidebar hide.
	isVisible ifFalse: [ leftSidebar show: 3 ]
    ]

    historyChanged [
	<category: 'public'>

	self currentWidgetOfBrowser ifNotNil: [ :w |
	    historyWidget refresh: w historyStack ]
    ]

    previousTab [
	<category: 'tabs events'>

	browsers currentPage > 0 
		    ifTrue: [ browsers currentPage: browsers currentPage - 1 ]
		    ifFalse: [ browsers currentPage: browsers numberOfPages - 1 ] 
    ]

    nextTab [
	<category: 'tabs events'>

	browsers currentPage: (browsers currentPage + 1 \\ browsers numberOfPages)
    ]

    closeTab [
	<category: 'tabs events'>

	browsers numberOfPages > 1 
			    ifTrue: [ browsers currentWidget checkCodeWidgetAndUpdate: [ browsers closeCurrentPage ] ]
			    ifFalse: [ browsers closeCurrentPage ].
    ]

    currentWidgetOfBrowser [
	<category: 'browsers'>

	^ browsers currentWidget
    ]

    senderSelected [
        <category: 'events'>

        senderWidget hasSelection ifFalse: [ ^ self ].
        self findInMethod: (senderWidget matchSelector: senderWidget selection) values first element
    ]

    implementorSelected [
        <category: 'events'>

        implementorWidget hasSelection ifFalse: [ ^ self ].
        self imageSelectorForImplementor: implementorWidget selection
    ]

    senderSelected [
	<category: 'events'>

        senderWidget hasSelection ifFalse: [ ^ self ].
        self imageSelectorForSender: senderWidget selection
    ]

    imageSelectorForImplementor: aSymbol [
        <category: 'events'>

	implementorResultWidget appendImplementorResults: (implementorWidget matchSelector: aSymbol)
    ]

    imageSelectorForSender: aSymbol [
        <category: 'events'>

	senderResultWidget appendSenderResults: (senderWidget matchSelector: aSymbol)
    ]

    resultImplementorSelected [
        <category: 'events'>

	implementorResultWidget selectedResult: self currentWidgetOfBrowser
    ]

    resultSenderSelected [
        <category: 'events'>

        senderResultWidget selectedResult: self currentWidgetOfBrowser
    ]

    keyPressedOn: aGtkWidget keyEvent: aGdkEventKey [
        <category: 'key event'>

        | event |
        event := aGdkEventKey castTo: GTK.GdkEventKey type.

	(event state value bitAnd: GTK.Gdk gdkControlMask) = 0 ifTrue: [ ^ false ].
	(#(65417 65289 65056) includes: event keyval value) ifFalse: [ ^ false ].
	(event state value bitAnd: GTK.Gdk gdkShiftMask) = 0  
					    ifFalse: [ self previousTab ]
					    ifTrue: [ self nextTab ].
        ^ true
    ]

    undoStack [
	<category: 'accessing'>

	^undoStack
    ]

]
