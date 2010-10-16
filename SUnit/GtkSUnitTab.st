GtkEditTab subclass: GtkSUnitTab [
    | namespaceWidget classWidget iMethodWidget successfullWidget failedWidget errorWidget |

    GtkSUnitTab class >> loadTest: aPackage [
        <category: 'private'>
        "I load the unit tests for one package"

        | test files |

        aPackage ifNil: [^self].

        test := aPackage test.
        test ifNil: [^self].

        test fileIn.
    ]

    GtkSUnitTab class >> loadTests [
        <category: 'run events'>
        "I load the unit tests for the loaded packages"

        Smalltalk Features do: [:each | |package|
                package := PackageLoader packageAt: each ifAbsent: [nil].
                self loadTest: package.
        ]
    ]

    "createRunMenus [
        <category: 'user interface'>

        ^{
                GTK.GtkMenuItem menuItem: 'Load tests' connectTo: self selector: #loadTests.
                GTK.GtkMenuItem menuItem: 'Run test' connectTo: self selector: #runTest.
                GTK.GtkMenuItem menuItem: 'Debug test' connectTo: self selector: #debugTest}
    ]"

    "createToolbar [
        <category: 'user interface'>

        super createToolbar.
        self
            appendSeparator;
            appendToolItem: ((GTK.GtkToolButton new: (GTK.GtkImage newFromFile: (GtkLauncher / 'Icons/go-run.png') file displayString) label: 'Run test')
                                connectSignal: 'clicked' to: self selector: #runTest userData: nil;
                                setTooltipText: 'Run test';
                                yourself)
    ]"

    GtkSUnitTab class >> title [
	<category: 'accessing'>

	^ 'Gtk SUnit browser'
    ]

    buildBrowser [

	^ GTK.GtkHPaned addAll: {self buildCategoryAndClass. self buildInstanceMethodView}
    ]

    buildResultWidget [
        <category: 'user interface'>

        ^ GTK.GtkNotebook new
            appendPage: self buildSuccesfullWidget tabLabel: (GTK.GtkLabel new: 'Successful Tests');
            appendPage: self buildFailedWidget tabLabel: (GTK.GtkLabel new: 'Failed Tests');
            appendPage: self buildErrorWidget tabLabel: (GTK.GtkLabel new: 'Errors Tests');
            yourself
    ]

    buildCategoryAndClass [

	^ GTK.GtkHPaned addAll: {self buildNamespaceView. self buildClassView}
    ]

    buildNamespaceView [
	<category: 'user interface'>

	^ (namespaceWidget := self buildWidget: GtkCategorizedNamespaceWidget)
	    mainWidget
    ]

    buildClassView [
	<category: 'user interface'>

	^ (classWidget := self buildWidget: GtkClassSUnitWidget)
	    mainWidget
    ]

    buildWidget: aClass [
	<category: 'user interface'>

	^ aClass showAll
                browser: self;
                yourself
    ]

    buildInstanceMethodView [
        <category: 'user interface'>

        ^ (iMethodWidget := self buildWidget: GtkMethodWidget)
            browser: self;
	    mainWidget
    ]

    buildMiniBrowser [
        <category: 'user interface'>

	^ GTK.GtkVPaned new
	    pack1: self buildBrowser resize: true shrink: false;
	    pack2: (self buildCodeView: GtkSourceCodeWidget) resize: true shrink: true ;
	    showAll;
	    yourself
    ]

    buildResultWidget [
        <category: 'user interface'>

        ^ GTK.GtkNotebook new
            appendPage: self buildSuccesfullWidget tabLabel: (GTK.GtkLabel new: 'Successful Tests');
            appendPage: self buildFailedWidget tabLabel: (GTK.GtkLabel new: 'Failed Tests');
            appendPage: self buildErrorWidget tabLabel: (GTK.GtkLabel new: 'Errors Tests');
            yourself
    ]

    buildMainWidget [
        <category: 'intialize-release'>

        ^ (GTK.GtkVPaned new)
            pack1: self buildMiniBrowser resize: true shrink: false;
            pack2: self buildResultWidget resize: true shrink: false;
            showAll;
            yourself
    ]

    buildSuccesfullWidget [
        <category: 'user interface'>

        successfullWidget := GtkSUnitResult new
                                initialize;
                                yourself.

        ^ successfullWidget mainWidget
    ]

    buildFailedWidget [
        <category: 'user interface'>

        failedWidget := GtkSUnitResult new
                                initialize;
                                yourself.

        ^ failedWidget mainWidget
    ]

    buildErrorWidget  [
        <category: 'user interface'>

        errorWidget := GtkSUnitResult new
                                initialize;
                                yourself.

        ^ errorWidget mainWidget
    ]

    runSuite: aSuite [
        <category: 'run events'>

        | results |
        aSuite logPolicy: TestBacktraceLog new.
        results := aSuite run.

        successfullWidget results: results passed.
        failedWidget results: results failures.
        errorWidget results: results errors.
    ]

    postInitialize [
	<category: 'initialize'>

	super postInitialize.
        self updateState: (ClassState with: Object).
    ]

    acceptIt [
	<category: 'smalltalk events'>

        AcceptItCommand on: self
    ]

    fileoutNamespace [
	<category: 'namespace events'>

	FileoutNamespaceCommand on: self
    ]

    newNamespace [
	<category: 'namespace events'>

	AddNamespaceCommand on: self
    ]

    renameNamespace [
	<category: 'namespace events'>

	RenameNamespaceCommand on: self
    ]

    deleteNamespace [
	<category: 'namespace events'>

	DeleteNamespaceCommand on: self
    ]

    inspectNamespace [
	<category: 'namespace events'>

	InspectNamespaceCommand on: self
    ]

    fileoutClass [
	<category: 'class events'>
    
	FileoutClassCommand on: classWidget
    ]

    newClass [
	<category: 'class events'>
	
	AddClassCommand on: self
    ]

    renameClass [
	<category: 'class events'>

	RenameClassCommand on: self
    ]

    deleteClass [
	<category: 'class events'>

	DeleteClassCommand on: self
    ]

    inspectClass [
	<category: 'class events'>

	InspectClassCommand on: self
    ]

    deleteMethod [
	<category: 'method events'>

	DeleteMethodCommand on: self
    ]

    inspectMethod [
	<category: 'method events'>

	InspectMethodCommand on: self
    ]

    fileoutMethod [
	<category: 'method events'>

	FileoutMethodCommand on: self
    ]

    selectedNamespace [
	<category: 'selection'>

	^ namespaceWidget selectedNamespace
    ]

    selectNamespaceState: aState [
	<category: 'private-selection'>

        (namespaceWidget hasSelectedNamespace
            and: [namespaceWidget selectedNamespace = aState namespace])
                ifTrue: [^self].

        namespaceWidget selectANamespace: aState namespace.
        namespaceWidget selectAClassCategory: aState classCategory.
    ]

    acceptNamespaceState: aState [
	classWidget namespace: aState namespace category: aState classCategory fullname.
	self source: (NamespaceHeaderSource on: aState namespace).
    ]

    finishNamespaceState [
        classWidget unselectAll
    ]

    selectClassState: aState [
	<category: 'selection'>

        | classOrMeta |
        classOrMeta := aState classOrMeta.
        (classWidget hasSelectedClass
            and: [classWidget selectedClass = classOrMeta asClass])
	        ifTrue: [^self].

        classWidget selectAClass: classOrMeta asMetaclass
    ]

    acceptCategoryState: aState [
        iMethodWidget
             class: aState classOrMeta
             withCategory: '*'.
	self source: (ClassHeaderSource on: aState classOrMeta asClass).
    ]

    finishCategoryState [
        iMethodWidget unselectAll.
    ]

    selectMethodState: aState [
	<category: 'selection'>

        (iMethodWidget hasSelectedMethod
            and: [iMethodWidget selectedMethodSymbol = aState selector])
                ifTrue: [^self].

	iMethodWidget selectAMethod: aState selector.
    ]

    acceptMethodState: aState [
	<category: 'selection'>

	self source: (BrowserMethodSource on: aState method).
    ]

    finishMethodState [
	<category: 'selection'>

    ]

    doIt [
	<category: 'smalltalk event'>

	DoItCommand on: self
    ]

    debugIt [
	<category: 'smalltalk event'>

	DebugItCommand on: self
    ]

    inspectIt [
	<category: 'smalltalk event'>

	InspectItCommand on: self
    ]

    printIt [
	<category: 'smalltalk event'>

	PrintItCommand on: self
    ]
]

Eval [ GtkSUnitTab loadTests ]
