GtkConcreteWidget subclass: GtkClassBrowserWidget [
    GtkClassBrowserWidget class [ | Undo | ]

    | namespaceWidget classWidget classHierarchyWidget classHierarchyUpdate iCategoryWidget iMethodWidget cCategoryWidget cMethodWidget classAndInstanceSide codeWidget history historyUpdate |

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

    buildBrowser [

	^ GTK.GtkHPaned new
	    pack1: self buildCategoryClassesAndHierarchy resize: true shrink: false;
	    pack2: self buildProtocolAndMethod resize: true shrink: false;
	    showAll;
	    yourself
    ]

    buildCategoryAndClass [

	^ GTK.GtkHPaned new
	    pack1: self buildNamespaceView resize: true shrink: false;
            pack2: self buildClassView resize: true shrink: false;
	    showAll;
	    yourself
    ]

    buildClassBrowser [

	^ GTK.GtkHPaned new
            pack1: self buildClassCategoryView resize: true shrink: false;
            pack2: self buildClassMethodView resize: true shrink: false;
	    showAll;
	    yourself
    ]

    buildInstanceBrowser [

	^ GTK.GtkHPaned new
	    pack1: self buildInstanceCategoryView resize: true shrink: false;
	    pack2: self buildInstanceMethodView resize: true shrink: false;
	    showAll;
	    yourself
    ]

    buildProtocolAndMethod [

	^ classAndInstanceSide := (GTK.GtkNotebook new)
	    appendPage: self buildInstanceBrowser tabLabel: (GTK.GtkLabel new: 'Instance');
	    appendPage: self buildClassBrowser tabLabel: (GTK.GtkLabel new: 'Class');
	    showAll;
	    setCurrentPage: 0;
	    connectSignal: 'switch-page' to: self selector: #'classInstanceSwitchOn:page:number:' userData: nil;
	    yourself
    ]

    buildCategoryClassesAndHierarchy [

	^ (GTK.GtkNotebook new)
	    appendPage: self buildCategoryAndClass tabLabel: (GTK.GtkLabel new: 'Class');
	    appendPage: self buildHierarchy tabLabel: (GTK.GtkLabel new: 'Hierarchy');
	    showAll;
	    setCurrentPage: 0;
	    connectSignal: 'switch-page' to: self selector: #'namespaceHierarchySwitchOn:page:number:' userData: nil;
	    yourself
    ]

    buildNamespaceView [
	<category: 'user interface'>

	namespaceWidget := (GtkNamespaceWidget new)
				initialize;
				whenSelectionChangedSend: #onNamespaceChanged to: self;
				showAll;
				yourself.

	^ namespaceWidget mainWidget
    ]

    buildClassView [
	<category: 'user interface'>

	classWidget := (GtkClassWidget new)
			    initialize;
			    whenSelectionChangedSend: #onClassChanged to: self;
			    showAll;
			    yourself.

	^ classWidget mainWidget
    ]

    buildCodeView [
	<category: 'user interface'>

	codeWidget := (GtkSourceCodeWidget new)
			initialize;
			parentWindow: self parentWindow;
			showAll;
			yourself.
    
	^ codeWidget mainWidget
    ]

    buildHierarchy [
	<category: 'user interface'>

	classHierarchyWidget := (GtkClassHierarchyWidget new)
				    initialize;
				    whenSelectionChangedSend: #onClassHierarchyChanged to: self;
				    showAll;
				    yourself.

	^ classHierarchyWidget mainWidget
    ]

    buildInstanceCategoryView [
        <category: 'user interface'>

        iCategoryWidget := (GtkCategoryWidget new)
                            initialize;
                            whenSelectionChangedSend: #onInstanceSideCategoryChanged to: self;
                            showAll;
                            yourself.

        ^ iCategoryWidget mainWidget
    ]

    buildClassCategoryView [
	<category: 'user interface'>

	cCategoryWidget := (GtkCategoryWidget new)
			    initialize;
			    whenSelectionChangedSend: #onClassSideCategoryChanged to: self;
			    showAll;
			    yourself.

	^ cCategoryWidget mainWidget
    ]

    buildClassMethodView [
	<category: 'user interface'>

	cMethodWidget := (GtkMethodWidget new)
			    initialize;
			    whenSelectionChangedSend: #onClassSideMethodChanged to: self;
			    showAll;
			    yourself.

	^ cMethodWidget mainWidget
    ]

    buildInstanceMethodView [
        <category: 'user interface'>

        iMethodWidget := (GtkMethodWidget new)
                            initialize;
                            whenSelectionChangedSend: #onInstanceSideMethodChanged to: self;
                            showAll;
                            yourself.

        ^ iMethodWidget mainWidget
    ]

    initializeNotification [
	<category: 'initialize-release'>

	(SystemChangeNotifier uniqueInstance)
	    notify: GtkNamespaceModel ofSystemChangesOfItem: #namespace change: #Added using: #'addEvent:';
	    notify: GtkNamespaceModel ofSystemChangesOfItem: #namespace change: #Removed using: #'removeEvent:';
	    notify: GtkClassModel ofSystemChangesOfItem: #class change: #Added using: #'addEvent:';
	    notify: GtkClassModel ofSystemChangesOfItem: #class change: #Removed using: #'removeEvent:';
	    notify: GtkMethodModel ofSystemChangesOfItem: #method change: #Added using: #'addEvent:';
	    notify: GtkMethodModel ofSystemChangesOfItem: #method change: #Removed using: #'removeEvent:'
    ]

    initializeHistory [
	<category: 'initialize-release'>

	historyUpdate := true.
	history := HistoryStack new
		    initialize: self;
		    yourself
    ]

    initialize [
	<category: 'initialize-release'>

	| vpaned |
	classHierarchyUpdate := false.
	vpaned := GTK.GtkVPaned new.

	self mainWidget: vpaned.
	self initializeNotification.
	self initializeHistory.
 
	vpaned
	    pack1: self buildBrowser resize: true shrink: false;
	    pack2: self buildCodeView resize: true shrink: true ;
	    showAll
    ]

    namespaceHierarchySwitchOn: aGtkNotebook page: aGtkNotebookPage number: aSmallInteger [
	<category: 'events'>

	classWidget hasSelectedClass ifFalse: [ ^ self ].
	aSmallInteger = 0 ifTrue: [ classHierarchyWidget class: classWidget selectedClass ].
    ]

    classInstanceSwitchOn: aGtkNotebook page: aGtkNotebookPage number: aSmallInteger [
	<category: 'events'>

	aSmallInteger = 0 
	    ifTrue: [
		iMethodWidget hasSelectedMethod 
		    ifTrue: [ codeWidget sourceCode: iMethodWidget sourceCode ]
		    ifFalse: [ codeWidget clearCode ] ]
	    ifFalse: [
                cMethodWidget hasSelectedMethod
                    ifTrue: [ codeWidget sourceCode: cMethodWidget sourceCode ]
                    ifFalse: [ codeWidget clearCode ] ]
    ]

    onNamespaceChanged [
	<category: 'events'>

	| namespace |
	namespaceWidget hasSelectedNamespace ifFalse: [ ^ self ].
	namespace := namespaceWidget selectedNamespace.
	classWidget namespace: namespace.

	classHierarchyUpdate ifFalse: [ classHierarchyWidget emptyModel ].
	iCategoryWidget emptyModel.
	cCategoryWidget emptyModel.
	iMethodWidget emptyModel.
	cMethodWidget emptyModel.
	codeWidget namespaceDefinition: (NamespaceSource on: namespace)
    ]

    onClassChanged [
	<category: 'events'>

        | aClass |
	classWidget hasSelectedClass ifFalse: [ ^ self ].
	aClass := classWidget selectedClass.
	classHierarchyUpdate ifFalse: [ classHierarchyWidget class: aClass ].
	iCategoryWidget class: aClass.
	cCategoryWidget class: aClass class.
	iCategoryWidget unselectAll.
        cCategoryWidget unselectAll.

	historyUpdate ifTrue: [ history push: aClass ].

	iMethodWidget emptyModel.
        cMethodWidget emptyModel.
	codeWidget classDefinition: (ClassSource displayHeaderOf: aClass)
    ]

    onClassHierarchyChanged [
	<category: 'events'>

	| aClass |
	classHierarchyWidget hasSelectedClass ifFalse: [ ^ self ].
	classHierarchyUpdate := true.
        aClass := classHierarchyWidget selectedClass.
	namespaceWidget selectANamespace: aClass environment.
	classWidget selectAClass: aClass.
	classHierarchyUpdate := false
    ]

    onInstanceSideCategoryChanged [
	<category: 'events'>

	| category |
	iCategoryWidget hasSelectedCategory ifFalse: [ ^ self ].
	iMethodWidget class: classWidget selectedClass withCategory: iCategoryWidget selectedCategory.

	codeWidget clearCode 
    ]

    onClassSideCategoryChanged [
	<category: 'events'>
	
	cCategoryWidget hasSelectedCategory ifFalse: [ ^ self ].
	cMethodWidget class: classWidget selectedClass class withCategory: cCategoryWidget selectedCategory.

	codeWidget clearCode
    ]

    onInstanceSideMethodChanged [
	<category: 'events'>

	| method |
	iMethodWidget hasSelectedMethod ifFalse: [ ^ self ].
	method := iMethodWidget selectedMethod.
	codeWidget sourceCode: iMethodWidget sourceCode
    ]

    onClassSideMethodChanged [
	<category: 'events'>

	| method |
	cMethodWidget hasSelectedMethod ifFalse: [ ^ self ].
	method := cMethodWidget selectedMethod.
	codeWidget sourceCode: cMethodWidget sourceCode
    ]

    saveContents [
	<category: 'events'>

       "(self selectedClass isNil or: [self selectedMethod isNil])
	    ifTrue: [ ^ GtkMessageDialog error: 'Unable to save contents' ].
	self selectedClass compile: codeBuffer text classified: self selectedMethodCategory.
	saveButton sensitive: false"
    ]

    undoStack [
	<category: 'accessings'>

	^ self class undoStack
    ]

    undo [
	<category: 'edit events'>

	self undoStack undo
    ]

    redo [
	<category: 'edit events'>

	self undoStack redo
    ]

    acceptIt [
	<category: 'smalltalk events'>

        | categoryWidget |
	namespaceWidget hasSelectedNamespace ifFalse: [ ^ self ].
	categoryWidget := self viewedCategoryWidget.
        categoryWidget hasSelectedCategory ifFalse: [ ^ self acceptClassDefinition ].
	self newMethod
    ]
    
    acceptClassDefinition [
	<category: 'class event'>

	^ (ReadStream on: codeWidget sourceCode) fileIn
    ]

    fileoutNamespace: aDirectory [
	<category: 'namespace events'>

	| namespace stream |
	namespaceWidget hasSelectedNamespace ifFalse: [ ^ self ].
	namespace := namespaceWidget selectedNamespace.
	self fileoutNamespace: namespace on: (File name: aDirectory) / namespace name
    ]

    fileoutNamespace: aNamespace on: aDirectory [
	<category: 'namespace events'>

	| stream |
	aDirectory exists ifFalse: [ aDirectory createDirectory ].
	stream := FileStream open: (aDirectory / 'self.st') asString mode: FileStream write.
	(NamespaceSource write: aNamespace on: stream)
                header.
	aNamespace do: [ :each |
	    (each isNil not and: [ each isClass and: [ each environment = aNamespace ] ])
		    ifTrue: [ stream := FileStream open: (aDirectory / ((each name asString) , '.st')) asString mode: FileStream write.
			    (ClassSource write: each on: stream)
				source ] ].
	aNamespace allSubspacesDo: [ :space |
            | dir |
            dir := (aDirectory / space name).
	    self fileoutNamespace: space on: dir ]
    ]

    fileoutProject [
        <category: 'namespace events'>

        | namespace stream parentDir |
        namespaceWidget hasSelectedNamespace ifFalse: [ ^ self ].
        namespace := namespaceWidget selectedNamespace.
	parentDir := (Directory home / 'Temp' / namespace name).
	self fileoutNamespace: namespace on: parentDir
    ]

    hasSelectedNamespace [
	<category: 'testing'>

	^ namespaceWidget hasSelectedNamespace
    ]

    selectedNamespace [
	<category: 'testing'>

	^ namespaceWidget selectedNamespace
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

	namespaceWidget hasSelectedNamespace ifFalse: [ ^ self ].
	GtkInspector openOn: namespaceWidget selectedNamespace
    ]

    fileoutClass: aFile [
        <category: 'class events'>

        | class stream |
        classWidget hasSelectedClass ifFalse: [ ^ self ].
        class := classWidget selectedClass.
        stream := FileStream open: aFile mode: FileStream write.
        (ClassSource write: class on: stream)
	    source
    ]

    extractNamespaceFrom: aNamespace [
	<category: 'namespace as directory'>

	| list namespace |
	namespace := aNamespace.
	list := OrderedCollection new.
	[ namespace isNil ] whileFalse: [
            list addFirst: namespace displayString.
            namespace := namespace superspace ].
	^ list
    ]

    fileoutClassInProject [
	<category: 'class events'>

	| class dir namespace stream |
	classWidget hasSelectedClass ifFalse: [ ^ self ].
	class := classWidget selectedClass.
	dir := Directory home / 'Temp'.
	(self extractNamespaceFrom: class environment) do: 
	    [ :each | dir := dir / each.
	    dir exists ifFalse: [ dir createDirectory ] ].
	stream := FileStream open: (dir / (class name asString), '.st') asString mode: FileStream write.
	(ClassSource write: class on: stream)
            source
    ]

    hasSelectedClass [
	<category: 'accessing'>

	^ classWidget hasSelectedClass
    ]

    selectedClass [
	<category: 'accessing'>

	^ classWidget selectedClass
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

	classWidget hasSelectedClass ifFalse: [ ^ self ].
	GtkInspector openOn: classWidget selectedClass
    ]

    classOrMetaSelected [
	<category: 'class accessing'>

	| class |
	classWidget hasSelectedClass ifFalse: [ ^ self ].
	class := classWidget selectedClass.
	^ classAndInstanceSide getCurrentPage = 0
            ifTrue: [ class ]
            ifFalse: [ class class ]	
    ]

    viewedCategoryWidget [
         <category: 'category events'>

        ^ classAndInstanceSide getCurrentPage = 0
            ifTrue: [ iCategoryWidget ]
            ifFalse: [ cCategoryWidget ]
   ]

    viewedCategoryModel [
	<category: 'category events'>

	^ classAndInstanceSide getCurrentPage = 0
            ifTrue: [ GtkCategoryModel currentOn: classWidget selectedClass ]
            ifFalse: [ GtkCategoryModel currentOn: classWidget selectedClass class ]
    ]

    fileoutCategory: aFile [
        <category: 'class events'>

        | categoryWidget stream |
        classWidget hasSelectedClass ifFalse: [ ^ self ].
        categoryWidget := self viewedCategoryWidget.
        categoryWidget hasSelectedCategory ifFalse: [ ^ self ].
	stream := FileStream open: aFile mode: FileStream write.
	(CategorySource write: categoryWidget selectedCategory of: self classOrMetaSelected on: stream)
	    source
    ]

    hasSelectedCategory [
	<category: 'testing'>
	
	^ self viewedCategoryWidget hasSelectedCategory
    ]

    selectedCategory [
	<category: 'accessing'>

	^ self viewedCategoryWidget selectedCategory
    ]

    newCategory [
        <category: 'category events'>

	classWidget hasSelectedClass ifFalse: [ ^ self ].
	AddCategoryCommand on: self
    ]

    renameCategory [
        <category: 'category events'>

	classWidget hasSelectedClass ifFalse: [ ^ self ].
	RenameCategoryCommand on: self
    ]

    deleteCategory [
        <category: 'category events'>

	classWidget hasSelectedClass ifFalse: [ ^ self ].
	DeleteCategoryCommand on: self
    ]

    inspectCategory [
        <category: 'category events'>

    ]

    viewedMethodWidget [
         <category: 'category events'>

        ^ classAndInstanceSide getCurrentPage = 0
            ifTrue: [ iMethodWidget ]
            ifFalse: [ cMethodWidget ]
   ]

    viewedMethodModel [
        <category: 'category events'>

        ^ classAndInstanceSide getCurrentPage = 0
            ifTrue: [ GtkMethodModel currentOn: classWidget selectedClass withCategory: iCategoryWidget selectedCategory ]
            ifFalse: [ GtkMethodModel currentOn: classWidget selectedClass class withCategory: cCategoryWidget selectedCategory ]
    ]

    hasSelectedMethod [
	<category: 'testing'>

	^ self viewedMethodWidget hasSelectedMethod
    ]

    selectedMethodSymbol [
	<category: 'accessing'>

	^ self viewedMethodWidget selectedMethodSymbol
    ]

    sourceCode [
	<category: 'accessing'>

	^ codeWidget sourceCode
    ]

    newMethod [
	<category: 'method events'>

	classWidget hasSelectedClass ifFalse: [ ^ self ].
	AddMethodCommand on: self
    ]


    deleteMethod [
	<category: 'method events'>

	classWidget hasSelectedClass ifFalse: [ ^ self ].
	DeleteMethodCommand on: self
    ]

    inspectMethod [
	<category: 'method events'>

	| methodWidget |
	classWidget hasSelectedClass ifFalse: [ ^ self ].
	methodWidget := self viewedMethodWidget.
        GtkInspector openOn: methodWidget selectedMethod
    ]

    fileoutMethod: aFile [
	<category: 'method events'>

        | methodWidget stream |
        classWidget hasSelectedClass ifFalse: [ ^ self ].
        methodWidget := self viewedMethodWidget.
        stream := FileStream open: aFile mode: FileStream write.
        (MethodSource write: methodWidget selectedMethod on: stream)
            source
    ]

    selectANamespace: aNamespace [
	<Category: 'selection'>

	namespaceWidget selectANamespace: aNamespace.
        classWidget namespace: aNamespace.

        classHierarchyWidget emptyModel.
        iCategoryWidget emptyModel.
        cCategoryWidget emptyModel.
        iMethodWidget emptyModel.
        cMethodWidget emptyModel.
        codeWidget namespaceDefinition: (NamespaceSource on: aNamespace)
    ]

    selectAClass: aClass [
	<category: 'selection'>

        classWidget selectAClass: aClass.
	classHierarchyWidget class: aClass.
        iCategoryWidget class: aClass.
        cCategoryWidget class: aClass class.

        iMethodWidget emptyModel.
        cMethodWidget emptyModel
    ]

    selectAnInstanceMethod: aSelector [
        <category: 'selection'>

        | class |
        class := classWidget selectedClass.

        class := (class selectors includes: aSelector) ifFalse: [ class class ] ifTrue: [ class ].
        iMethodWidget
            class: class withCategory: (class compiledMethodAt: aSelector) methodCategory
    ]

    selectAClassMethod: aSelector [
	<category: 'selection'>

        | class |
        class := classWidget selectedClass.

	class := (class selectors includes: aSelector) ifFalse: [ class class ] ifTrue: [ class ].
        cMethodWidget
            class: class withCategory: (class compiledMethodAt: aSelector) methodCategory
    ]

    doIt [
	<category: 'smalltalk event'>

	| class |
	classWidget hasSelectedClass ifFalse: [ ^ self ].

	class := classWidget selectedClass.

	codeWidget 
	    object: class;
	    doIt
    ]

    debugIt [
	<category: 'smalltalk event'>

        | class |
        classWidget hasSelectedClass ifFalse: [ ^ self ].

        class := classWidget selectedClass.

        codeWidget
            object: class;
            debugIt
    ]

    inspectIt [
	<category: 'smalltalk event'>

        | class |
        classWidget hasSelectedClass ifFalse: [ ^ self ].

        class := classWidget selectedClass.

        codeWidget
            object: class;
	    inspectIt
    ]

    printIt [
	<category: 'smalltalk event'>

        | class |
        classWidget hasSelectedClass ifFalse: [ ^ self ].

        class := classWidget selectedClass.

        codeWidget
            object: class;
            printIt
    ]

    forward [
	<category: 'history events'>

	history next
    ]

    back [
	<category: 'history events'>

	history previous
    ]

    updateClass: aClass [
	<category: 'history events'>

	historyUpdate := false.
	self selectAClass: aClass.
	historyUpdate := true.
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
]

