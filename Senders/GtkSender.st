GtkMainWindow subclass: GtkSender [
    | selector finderModel finderTree pathModel pathTree senderResults senderModel senderTree selectorModel selectorTree classBrowserWidget searchEntry |

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

        ^ self createMenuEntry: {#('New workspace' #newWorkspace).
            #().
            #('Open' #open).
            #('Save' #saveImage).
            #('Save as...' #saveImageAs).
            #().
            #('Print' #print).
            #().
            #('Save image' #saveImage).
            #('Save image as...' #saveImageAs).
            #().
            #('Quit' #quit)}
    ]

    createEditMenus [
        <category: 'user interface'>

        ^ self createMenuEntry: {#('Cut' #cut).
            #('Copy' #copy).
            #('Paste' #paste).
            #().
            #('Select all' #selectAll).
            #().
            #('Search' #searchClassOrMethod)}
    ]

    createToolsMenus [
        <category: 'user interface'>

        ^ self createMenuEntry:
            {#('Browser' #classBrowser).
            #('Browser window' #classBrowserInAWindow).
            #('Workspace' #workspace).
            #('Inspector' #gtkInspector).
            #().
            #('GtkDemo' #gtkDemo).
            #('SqueakZilla' #squeakzilla)}
    ]

    createHelpMenus [
        <category: 'user interface'>

        ^ self createMenuEntry: {#('About Smalltalk Sender' #aboutSender).
            #('About GNU Smalltalk' #aboutGst)}
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

	finderTree := GTK.GtkTreeView newWithSortedTextColumn: self finderModel title: 'Results'.
        (finderTree getColumn: 0) signalEmitByName: 'clicked' args: {}.
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

    pathModel [
	<category: 'model accessing'>

	^ pathModel ifNil: [
	    pathModel := GTK.GtkTreeStore new: 1 varargs: {GTK.GValue gTypeString} ]
    ]

    senderModel [
        <category: 'model accessing'>

        ^ senderModel ifNil: [
            senderModel := GTK.GtkTreeStore new: 1 varargs: {GTK.GValue gTypeString} ]
    ]

    selectorModel [
        <category: 'model accessing'>

        ^ selectorModel ifNil: [
            selectorModel := GTK.GtkTreeStore new: 1 varargs: {GTK.GValue gTypeString} ]
    ]

    buildPathTreeList [
	<category: 'user interface'>

	pathTree := GTK.GtkTreeView newWithSortedTextColumn: self pathModel title: 'Results'.
	(pathTree getColumn: 0) signalEmitByName: 'clicked' args: {}.
	pathTree
	    getSelection
		connectSignal: 'changed' to: self selector: #elementSelected userData: nil.
        ^ GTK.GtkScrolledWindow withChild: pathTree
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

	senderTree := GTK.GtkTreeView newWithSortedTextColumn: self senderModel title: 'Results'.
        senderTree
            getSelection
                connectSignal: 'changed' to: self selector: #senderSelected userData: nil.
        ^ GTK.GtkScrolledWindow withChild: senderTree
    ]

    buildSelectorList [
        <category: 'user interface'>

        selectorTree := GTK.GtkTreeView newWithSortedTextColumn: self selectorModel title: 'Results'.
        selectorTree
            getSelection
                connectSignal: 'changed' to: self selector: #resultSelected userData: nil.
        ^ GTK.GtkScrolledWindow withChild: selectorTree
    ]

    buildSenderAndSelectorList [
	<category: 'user interface'>

	^ GTK.GtkHPaned new
	    add1: (GTK.GtkHPaned new
			add1: self buildPathTreeList;
			add2: self buildSenderList;
			yourself);
	    add2: self buildSelectorList;
	    yourself
    ]

    buildSenderAndClassBrowser [
	<category: 'user interface'>

        ^ GTK.GtkVPaned new
            add1: self buildSenderAndSelectorList;
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
	finderTree setSearchEntry: searchEntry
    ]

    aboutSender [
        <category: 'events'>

        (GTK.GtkAboutDialog new)
            setVersion: '0.3.0';
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
            "setAuthors: {'Gwenael Casaccio'. 'Nicolas Petton'};"
            setProgramName: 'GNU Smalltalk Sender';
            run
    ]

    hasSelectedElement [
	<category: 'testing'>

	^ pathTree getSelection getSelected isNil not
    ]

    findInMethod: anObject [
	<category: 'find'>

	| result |
	anObject inspect.
	result := OrderedCollection new.
	CompiledMethod allInstancesDo: [ :each |
	    each literalsDo: [ :lit |
		lit = anObject ifTrue: [ result add: each ] ] ].
	^ result
    ]

    finderSelected [
	<category: 'finder events'>

	| iter result string |
	(iter := finderTree getSelection getSelected) ifNil: [ ^ self ].
	self senderModel clear.
	result := self findInMethod: (GtkImageModel current selectedItem: iter) first element.
	senderResults := OrderedCollection new.
	result do: [ :each |
	    senderResults add: each.
	    iter := GTK.GtkTreeIter new.
            self senderModel append: iter parent: nil.
            self senderModel setOop: iter column: 0 value: each displayString ]
    ]

    senderSelected [
	<category: 'sender events'>

	| count iter path selectedIter selectedString string |
        (selectedIter := senderTree getSelection getSelected) ifNil: [ ^ self ].
        selectedString := (self senderModel getOop: selectedIter column: 0).

        count := 1.
        iter := GTK.GtkTreeIter new.
        path := GTK.GtkTreePath newFirst.
        [ self senderModel getIter: iter path: path ] whileTrue: [
            string := (self senderModel getOop: iter column: 0).
            string = selectedString ifTrue: [ | method |
		method := senderResults at: count.
		classBrowserWidget
		    selectANamespace: method methodClass environment;
		    selectAClass: (method methodClass isClass ifTrue: [ method methodClass ] ifFalse: [ method methodClass instanceClass ]).
		    method methodClass isClass
			ifTrue: [ classBrowserWidget selectAnInstanceMethod: selector ]
			ifFalse: [ classBrowserWidget selectAClassMethod: selector  ].
                ^ self ].
            count := count + 1.
            path next ].
        ^ self error: 'error in the algorithm'
    ]

    elementSelected [
	<category: 'events'>

	"| iter string |
        (iter := pathTree getSelection getSelected) ifNil: [ ^ self ].
        string := (self model getOop: iter column: 0).
   
	self resultModel clear. 
	resultArray := finderDic at: string ifAbsent: [ self error: string, 'Element not found' ].
	resultArray size = 1 
	    ifTrue: [
		resultArray first updateBrowser: classBrowserWidget.
		resultArray first displayString printNl ]
	    ifFalse: [
		resultArray do: [ :each |
		    iter := GTK.GtkTreeIter new.
		    self resultModel append: iter parent: nil.
		    self resultModel setOop: iter column: 0 value: each displayString ] ]
	"	
    ]

    resultSelected [
	<category: 'events'>

	"| count iter path selectedIter selectedString string |
	(selectedIter := resultTree getSelection getSelected) ifNil: [ ^ self ].
	selectedString := (self resultModel getOop: selectedIter column: 0).

	count := 1.
        iter := GTK.GtkTreeIter new.
        path := GTK.GtkTreePath newFirst.
	[ self resultModel getIter: iter path: path ] whileTrue: [
	    string := (self resultModel getOop: iter column: 0).
	    string = selectedString ifTrue: [
		(resultArray at: count) updateBrowser: classBrowserWidget.
                (resultArray at: count) displayString printNl.
		^ self ].
	    count := count + 1.
	    path next ].
	^ self error: 'error in the algorithm'"
    ]
]

