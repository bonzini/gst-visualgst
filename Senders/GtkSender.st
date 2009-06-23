GtkMainWindow subclass: GtkSender [
    | currentMethod selector finderModel finderTree senderResults senderModel senderTree classBrowserWidget searchEntry |

    GtkSender class >> openOn: aSelector [
	<category: 'instance creation'>

	^ (self new)
            initialize;
            selector: aSelector;
            showAll;
            yourself
    ]

    selector: aSelector [
	<category: 'accessor'>

	selector := aSelector
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

    createEditMenus [
        <category: 'user interface'>

        ^ self createMenuEntry: {#('Cut' #cut '').
            #('Copy' #copy '').
            #('Paste' #paste '').
            #().
            #('Select all' #selectAll '').
            #().
            #('Search' #searchClassOrMethod '')}
    ]

    createToolsMenus [
        <category: 'user interface'>

        ^ self createMenuEntry:
            {#('Browser' #classBrowser '').
            #('Browser window' #classBrowserInAWindow '').
            #('Workspace' #workspace '').
            #('Inspector' #gtkInspector '').
            #().
            #('GtkDemo' #gtkDemo '').
            #('SqueakZilla' #squeakzilla '')}
    ]

    createHelpMenus [
        <category: 'user interface'>

        ^ self createMenuEntry: {#('About Smalltalk Sender' #aboutSender '').
            #('About GNU Smalltalk' #aboutGst '')}
    ]

    createMenus [
        <category: 'user interface'>

        self addMenuItem: 'File' withSubmenu: self createFileMenus.
        self addMenuItem: 'Edit' withSubmenu: self createEditMenus.
        self addMenuItem: 'Tools' withSubmenu: self createToolsMenus.
        self addMenuItem: 'Help' withSubmenu: self createHelpMenus
    ]


    createStatusBar [
        <category: 'user interface'>

        self statusMessage: 'Gtk Smalltalk Sender'
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
            appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-execute');
	    appendSeparator.
	    temp := (GTK.GtkToolItem new)
                        add: (GTK.GtkEntry new);
                        yourself.
            self toolBar insert: temp pos: -1

    ]

    buildFinderEntry [
	<category: 'user interface'>

	searchEntry := GTK.GtkEntry new.
	^ (GTK.GtkHBox new: true spacing: 3)
	    add: (GTK.GtkLabel new: 'Class or method :');
	    add: searchEntry;
	    yourself
    ]

    buildFinderTree [
	<category: 'user interface'>

	finderTree := GTK.GtkTreeView newWithSortedTextColumn: self finderModel title: 'Selectors'.
        GtkImageModel current isSorted ifFalse: [
	    (finderTree getColumn: 0) signalEmitByName: 'clicked' args: {}.
	    GtkImageModel current isSorted: true ].
        finderTree
            getSelection
                connectSignal: 'changed' to: self selector: #finderSelected userData: nil.
        ^ GTK.GtkScrolledWindow withChild: finderTree
    ]

    finderModel [
	<category: 'model accessing'>

	^ finderModel ifNil: [
	    finderModel := GtkImageModel currentModel ]
    ]

    senderModel [
        <category: 'model accessing'>

        ^ senderModel ifNil: [
            senderModel := GTK.GtkListStore new: 1 varargs: {GTK.GValue gTypeString} ]
    ]

    clearSenderModel [
	<category: 'model cleaning'>

	self senderModel clear
    ]

    buildFinderList [
	<category: 'user interface'>

	^ GTK.GtkVPaned new
            add1: self buildFinderEntry;
            add2: self buildFinderTree;
            yourself
    ]

    buildSenderList [
        <category: 'user interface'>

	senderTree := GTK.GtkTreeView newWithSortedTextColumn: self senderModel title: 'Senders'.
	(senderTree getColumn: 0) signalEmitByName: 'clicked' args: {}.
        senderTree
            getSelection
                connectSignal: 'changed' to: self selector: #senderSelected userData: nil.
        ^ GTK.GtkScrolledWindow withChild: senderTree
    ]

    buildSenderAndClassBrowser [
	<category: 'user interface'>

        ^ GTK.GtkVPaned new
            add1: self buildSenderList;
            add2: ((classBrowserWidget := GtkClassBrowserWidget new)
                        initialize;
                        mainWidget);
            yourself
    ]

    buildCentralWidget [
        <category: 'intialize-release'>

	^ (GTK.GtkHPaned new)
	    add1: self buildFinderList;
	    add2: self buildSenderAndClassBrowser;
	    yourself
    ]

    initialize [
        <category: 'initialization'>

        super initialize.
        self
            title: 'GNU Smalltalk Sender';
            createMenus;
            createToolbar;
            createStatusBar;
            centralWidget: self buildCentralWidget.
	finderTree setSearchEntry: searchEntry.
    ]

    aboutSender [
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
            setComments: 'This is a GTK+ wrapper for GNU Smalltalk.';
            "setAuthors: {'Gwenael Casaccio'. 'Nicolas Petton'};"
            setProgramName: 'GNU Smalltalk Sender';
            run
    ]

    findInMethod: anObject [
	<category: 'find'>

	| result |
	result := Dictionary new.
	CompiledMethod allInstancesDo: [ :each |
	    each literalsAndSpecialSelectorsDo: [ :lit | lit = anObject ifTrue: [ result at: each displayString put: each ] ] ].
	^ result
    ]

    appendSelectors: aCompiledMethod [
	<category: 'selector accessing'>

	| iter |
	self selectorModel clear.
	aCompiledMethod literalsAndSpecialSelectorsDo: [ :each |
	    each isSymbol ifTrue: [
		iter := self selectorModel insertBefore: nil.
		self selectorModel setOop: iter column: 0 value: each asString ] ]
    ]

    finderSelected [
	<category: 'finder events'>

	| iter result string |
	(iter := finderTree getSelection getSelected) ifNil: [ ^ self ].

	self clearSenderModel.

	[ senderResults := self findInMethod: (GtkImageModel current selectedItem: iter) values first element.
	senderResults keysAndValuesDo: [ :key :value |
	    iter := self senderModel insertBefore: nil.
	    self senderModel setOop: iter column: 0 value: key ] ] forkAt: Processor highestPriority
    ]

    senderSelected [
	<category: 'sender events'>

	| count iter path selectedIter selectedString string |
        (selectedIter := senderTree getSelection getSelected) ifNil: [ ^ self ].
        selectedString := (self senderModel getOop: selectedIter column: 0).
	currentMethod := senderResults at: selectedString ifAbsent: [ ^ self error: selectedString, 'not in the list' ].

        classBrowserWidget
                selectANamespace: currentMethod methodClass environment;
                selectAClass: (currentMethod methodClass isClass ifTrue: [ currentMethod methodClass ] ifFalse: [ currentMethod methodClass instanceClass ]).
        currentMethod methodClass isClass
                ifTrue: [ classBrowserWidget selectAnInstanceMethod: currentMethod selector ]
                ifFalse: [ classBrowserWidget selectAClassMethod: currentMethod selector  ]
    ]
]

