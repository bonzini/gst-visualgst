GtkConcreteWidget subclass: GtkClassBrowserWidget [
    GtkClassBrowserWidget class [ | Undo | ]

    | launcher checkCode namespaceWidget classWidget classHierarchyWidget iCategoryWidget iMethodWidget cCategoryWidget cMethodWidget classAndInstanceSide codeWidget historyStack state updating |

    GtkClassBrowserWidget class >> title [
	<category: 'accessing'>

	^ 'Gtk class browser'
    ]

    GtkClassBrowserWidget class >> undoStack [
	<category: 'accessing'>

        ^ Undo ifNil: [ Undo := (UndoStack new)
				    initialize;
				    yourself ]
    ]

    launcher: aGtkLauncher [
        <category: 'accessing'>

        launcher := aGtkLauncher
    ]
    
    launcher [
	<category: 'accessing'>

	^ launcher
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

    buildBrowserPaned [
        <category: 'user interface'>

	^ GTK.GtkVPaned new
	    pack1: self buildBrowser resize: true shrink: false;
	    pack2: self buildCodeView resize: true shrink: true ;
	    showAll;
	    yourself
    ]

    initialize [
	<category: 'initialize-release'>

	historyStack := HistoryStack new.
	checkCode := true.
        updating := false.

	self 
	    mainWidget: self buildBrowserPaned
    ]

    postInitialize [
	<category: 'initialize'>

        self updateState: (ClassState with: Object).
	codeWidget postInitialize
    ]

    updateHistory: aClass [
	<category: 'history'>

    ]

    historyStack [
	<category: 'history'>

        ^historyStack
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

    undoStack [
	<category: 'accessings'>

	^ self class undoStack
    ]

    cancel [
	<category: 'edit events'>

	codeWidget hasFocus ifTrue: [ ^codeWidget cancel ]
    ]

    undo [
	<category: 'edit events'>

	codeWidget hasFocus 
	    ifTrue: [ codeWidget undo ]
	    ifFalse: [ self undoStack undo ]
    ]

    redo [
	<category: 'edit events'>

        codeWidget hasFocus
            ifTrue: [ codeWidget redo ]
            ifFalse: [ self undoStack redo ]
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

    selectEmptyState [
	<category: 'state-callbacks'>
        "TODO"
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

    selectANamespace: aNamespace [
        ^self updateState: (NamespaceState with: aNamespace)
    ]

    selectAClass: aClass [
        ^self updateState: (ClassState with: aClass)
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

    selectAnInstanceMethod: aSelector [
        <category: 'selection'>

	self updateState: (MethodState state: self classOrMeta asClass >> aSelector)
    ]

    selectAClassMethod: aSelector [
	<category: 'selection'>

	self updateState: (MethodState state: self classOrMeta asMetaclass >> aSelector)
    ]

    targetObject [
        <category: 'target'>

        ^ self state classOrMeta
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

    forward [
	<category: 'history events'>

	self updateState: historyStack next.
        launcher isNil ifFalse: [ launcher historyChanged ]
    ]

    back [
	<category: 'history events'>

	self updateState: historyStack previous.
        launcher isNil ifFalse: [ launcher historyChanged ]
    ]

    sourceCodeWidgetHasFocus [
	<category: 'testing'>

	^ parentWindow getFocus address = codeWidget textview address
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

    doNotCheckCode [
	<category: 'text editing'>

	checkCode := false
    ]

    checkCodeWidgetAndUpdate: aBlock [
        <category: 'text editing'>

        self saveCodeOr: [ self clearUndo. aBlock value ]
    ]

    saveCodeOr: dropBlock [
        <category: 'saving'>

        | dialog |
        checkCode ifFalse: [ checkCode := true. dropBlock value. ^ self ].
        self hasChanged ifFalse: [ dropBlock value. ^ self ].
        dialog := GTK.GtkMessageDialog
                                new: self parentWindow
                                flags: GTK.Gtk gtkDialogDestroyWithParent
                                type: GTK.Gtk gtkMessageWarning
                                buttons: GTK.Gtk gtkButtonsNone
                                message: 'Accept changes before exiting?'
                                tip: 'If you do not accept them, your changes to %1 will be lost...' % {self state}.

        dialog
            addButton: 'Drop' responseId: 0;
            addButton: 'Cancel' responseId: 2;
            addButton: 'Accept' responseId: 1;
            showModalOnAnswer: [ :dlg :res |
                res = 1 ifTrue: [ self acceptIt ].
                res <= 1 ifTrue: dropBlock.
                dlg destroy ].
    ]

    state [
	<category: 'accessing'>

	^ state
    ]

    updateState: newState [
	<category: 'accessing'>
        updating ifTrue: [^self].
        newState isNil ifTrue: [^self].
        self checkCodeWidgetAndUpdate: [ self state: newState ]
    ]

    state: aState [
	<category: 'accessing'>

        | saveUpdating |
        self state = aState ifTrue: [^self].
        saveUpdating := updating.
        updating := true.
        state := aState.
        aState selectInBrowser: self.
        historyStack push: aState.
        updating := saveUpdating.

        launcher isNil ifFalse: [ launcher historyChanged ]
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

    close [
	<category: 'user interface'>

	self checkCodeWidgetAndUpdate: []
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

