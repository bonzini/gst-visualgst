GtkLauncherTab subclass: GtkClassBrowserWidget [
    | namespaceWidget classWidget classHierarchyWidget iCategoryWidget iMethodWidget cCategoryWidget cMethodWidget classAndInstanceSide codeWidget |

    GtkClassBrowserWidget class >> title [
	<category: 'accessing'>

	^ 'Gtk class browser'
    ]

    buildBrowser [

	^ GTK.GtkHPaned addAll: {self buildCategoryClassesAndHierarchy. self buildProtocolAndMethod}
    ]

    buildCategoryAndClass [

	^ GTK.GtkHPaned addAll: {self buildNamespaceView. self buildClassView}
    ]

    buildClassBrowser [

	^ GTK.GtkHPaned addAll: {self buildClassCategoryView. self buildClassMethodView}
    ]

    buildInstanceBrowser [

	^ GTK.GtkHPaned addAll: {self buildInstanceCategoryView. self buildInstanceMethodView}
    ]

    buildProtocolAndMethod [

	^ classAndInstanceSide := (GTK.GtkNotebook new)
	    appendPage: self buildInstanceBrowser tabLabel: (GTK.GtkLabel new: 'Instance');
	    appendPage: self buildClassBrowser tabLabel: (GTK.GtkLabel new: 'Class');
	    showAll;
	    setCurrentPage: 0;
	    connectSignal: 'switch-page' to: self selector: #'classInstanceSwitchOn:page:number:';
	    yourself
    ]

    buildCategoryClassesAndHierarchy [

	^ (GTK.GtkNotebook new)
	    appendPage: self buildCategoryAndClass tabLabel: (GTK.GtkLabel new: 'Class');
	    appendPage: self buildHierarchy tabLabel: (GTK.GtkLabel new: 'Hierarchy');
	    showAll;
	    setCurrentPage: 0;
	    yourself
    ]

    buildNamespaceView [
	<category: 'user interface'>

	^ (namespaceWidget := self buildWidget: GtkCategorizedNamespaceWidget)
	    mainWidget
    ]

    buildClassView [
	<category: 'user interface'>

	^ (classWidget := self buildWidget: GtkCategorizedClassWidget)
	    mainWidget
    ]

    buildCodeView [
	<category: 'user interface'>

	codeWidget := GtkSourceCodeWidget showAll 
			parentWindow: self parentWindow;
			browser: self;
			yourself.
    
	^ codeWidget mainWidget
    ]

    buildWidget: aClass [
	<category: 'user interface'>

	^ aClass showAll
                browser: self;
                yourself
    ]

    buildHierarchy [
	<category: 'user interface'>

	^ (classHierarchyWidget := self buildWidget: GtkClassHierarchyWidget)
	    mainWidget
    ]

    buildInstanceCategoryView [
        <category: 'user interface'>

        ^ (iCategoryWidget := self buildWidget: GtkCategoryWidget)
	    mainWidget
    ]

    buildClassCategoryView [
	<category: 'user interface'>

	^ (cCategoryWidget := self buildWidget: GtkCategoryWidget)
	    mainWidget
    ]

    buildClassMethodView [
	<category: 'user interface'>

	^ (cMethodWidget := self buildWidget: GtkMethodWidget)
            browser: self;
	    mainWidget
    ]

    buildInstanceMethodView [
        <category: 'user interface'>

        ^ (iMethodWidget := self buildWidget: GtkMethodWidget)
            browser: self;
	    mainWidget
    ]

    buildMainWidget [
        <category: 'user interface'>

	^ GTK.GtkVPaned new
	    pack1: self buildBrowser resize: true shrink: false;
	    pack2: self buildCodeView resize: true shrink: true ;
	    showAll;
	    yourself
    ]

    postInitialize [
	<category: 'initialize'>

	super postInitialize.
        self updateState: (ClassState with: Object).
	codeWidget postInitialize
    ]

    grabFocus [
	<category: 'user interface'>

	namespaceWidget mainWidget grabFocus
    ]

    classInstanceSwitchOn: aGtkNotebook page: aGtkNotebookPage number: aSmallInteger [
	<category: 'events'>

        | classState |
	self state hasSelectedClass ifFalse: [ ^self ].
        classState := ClassState with: (
	    aSmallInteger = 0 
		ifTrue: [ self state classOrMeta asClass ]
		ifFalse: [ self state classOrMeta asMetaclass ]).

        self updateState: classState
    ]

    cancel [
	<category: 'edit events'>

	codeWidget hasFocus ifTrue: [ ^codeWidget cancel ]
    ]

    undo [
	<category: 'edit events'>

	codeWidget hasFocus 
	    ifTrue: [ codeWidget undo ]
	    ifFalse: [ super undo ]
    ]

    redo [
	<category: 'edit events'>

        codeWidget hasFocus
            ifTrue: [ codeWidget redo ]
            ifFalse: [ super redo ]
    ]

    acceptIt [
	<category: 'smalltalk events'>

        AcceptItCommand executeOn: self
    ]

    viewedCategoryWidget [
         <category: 'category events'>

        ^ classAndInstanceSide getCurrentPage = 0
            ifTrue: [ iCategoryWidget ]
            ifFalse: [ cCategoryWidget ]
   ]

    viewedCategoryModel [
	<category: 'category events'>

	^ self viewedCategoryWidget model 
    ]

    categoryWidgetFor: aClass [
         <category: 'category events'>

        ^ aClass isMetaclass
            ifTrue: [ cCategoryWidget ]
            ifFalse: [ iCategoryWidget ]
   ]

    methodWidgetFor: aClass [
         <category: 'category events'>

        ^ aClass isMetaclass
            ifTrue: [ cMethodWidget ]
            ifFalse: [ iMethodWidget ]
   ]

    viewedMethodWidget [
         <category: 'category events'>

        ^ classAndInstanceSide getCurrentPage = 0
            ifTrue: [ iMethodWidget ]
            ifFalse: [ cMethodWidget ]
   ]

    sourceCode [
	<category: 'accessing'>

	^ codeWidget sourceCode
    ]

    compileError: aString line: line [
        <category: 'method events'>

        codeWidget compileError: aString line: line
    ]

    selectedNamespace [
	<category: 'selection'>

	^ namespaceWidget selectedNamespace
    ]

    selectedClassCategory [
	<category: 'selection'>

	^ namespaceWidget selectedCategory
    ]

    clearMethods [
	<category: 'private-selection'>

        iMethodWidget clear.
        cMethodWidget clear
    ]

    clearSource [
	<category: 'private-selection'>

	codeWidget clear
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
	        ifFalse: [classWidget selectAClass: classOrMeta asMetaclass].
        (classHierarchyWidget hasSelectedClass
            and: [classHierarchyWidget selectedClass = classOrMeta asClass])
	        ifFalse: [classHierarchyWidget selectAClass: classOrMeta asMetaclass].
    ]

    acceptClassState: aState [
        | classOrMeta |
        classOrMeta := aState classOrMeta.
	classOrMeta isClass
            ifTrue: [ classAndInstanceSide setCurrentPage: 0 ]
            ifFalse: [ classAndInstanceSide setCurrentPage: 1 ].

	iCategoryWidget classOrMeta: classOrMeta asClass.
	cCategoryWidget classOrMeta: classOrMeta asMetaclass.

	self source: (ClassHeaderSource on: classOrMeta asClass).
    ]

    finishClassState [
	cCategoryWidget unselectAll.
	iCategoryWidget unselectAll.
        self clearMethods.
    ]

    selectCategoryState: aState [
	<category: 'selection'>

        | aCategoryWidget |
        aCategoryWidget := self categoryWidgetFor: aState classOrMeta.
        (aCategoryWidget hasSelectedCategory
            and: [aCategoryWidget selectedCategory = aState category
                  or: [aCategoryWidget selectedCategory = '*']])
                ifTrue: [^self].

        aCategoryWidget selectACategory: aState category.
    ]

    acceptCategoryState: aState [
        | aCategoryWidget aMethodWidget |
        aCategoryWidget := self categoryWidgetFor: aState classOrMeta.
        aMethodWidget := self methodWidgetFor: aState classOrMeta.

        aMethodWidget
             class: aState classOrMeta
             withCategory: aCategoryWidget selectedCategory.

        self clearSource
    ]

    finishCategoryState [
        cMethodWidget unselectAll.
        iMethodWidget unselectAll.
    ]

    selectMethodState: aState [
	<category: 'selection'>

        | aMethodWidget |
        aMethodWidget := self methodWidgetFor: aState classOrMeta.
        (aMethodWidget hasSelectedMethod
            and: [aMethodWidget selectedMethodSymbol = aState selector])
                ifTrue: [^self].

	aMethodWidget selectAMethod: aState selector.
    ]

    acceptMethodState: aState [
	<category: 'selection'>

	self source: (BrowserMethodSource on: aState method).
    ]

    finishMethodState [
	<category: 'selection'>

    ]

    doIt: object [
	<category: 'smalltalk event'>

	codeWidget doIt: object
    ]

    debugIt: object [
	<category: 'smalltalk event'>

        codeWidget debugIt: object
    ]

    inspectIt: object [
	<category: 'smalltalk event'>

        codeWidget inspectIt: object
    ]

    printIt: object [
	<category: 'smalltalk event'>

        codeWidget printIt: object
    ]

    doIt [
	<category: 'smalltalk event'>

	DoItCommand executeOn: self
    ]

    debugIt [
	<category: 'smalltalk event'>

	DebugItCommand executeOn: self
    ]

    inspectIt [
	<category: 'smalltalk event'>

	InspectItCommand executeOn: self
    ]

    printIt [
	<category: 'smalltalk event'>

	PrintItCommand executeOn: self
    ]

    sourceCodeWidgetHasFocus [
	<category: 'testing'>

	^ parentWindow getFocus = codeWidget textview
    ]

    copy [
        <category: 'text editing'>

	codeWidget copy
    ]

    cut [
        <category: 'text editing'>

	codeWidget cut
    ]

    paste [
        <category: 'text editing'>

	codeWidget paste
    ]

    selectAll [
        <category: 'text editing'>

	codeWidget selectAll
    ]
 
    hasSelection [
	<category:'text testing'>

	^ codeWidget hasSelection
    ]
 
    selectedMethodSymbol [
        <category: 'text editing'>

        ^codeWidget selectedMethodSymbol
    ]

    selectedText [
	<category: 'text editing'>

	^ codeWidget selectedText
    ]

    clearUndo [
	<category: 'code saved'>

	codeWidget clearUndo
    ]

    source: aSourceFormatter [
	<category: 'code saved'>

	codeWidget source: aSourceFormatter
    ]

    codeSaved [
	<category: 'code saved'>

	codeWidget codeSaved
    ]

    hasChanged [
	<category: 'testing'>

	^ codeWidget hasChanged
    ]

    showFind [
	<category: 'user interface'>

	codeWidget showFind
    ]

    showReplace [
	<category: 'user interface'>

	codeWidget showReplace
    ]
]

