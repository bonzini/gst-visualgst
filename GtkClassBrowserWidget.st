GtkConcreteWidget subclass: GtkClassBrowserWidget [
    | namespaceWidget classWidget classHierarchyWidget classHierarchyUpdate iCategoryWidget iMethodWidget cCategoryWidget cMethodWidget classAndInstanceSide  codeWidget undoStack |

    GtkClassBrowserWidget class >> title [
	<category: 'accessing'>

	^ 'Gtk class browser'
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

    initialize [
	<category: 'initialize-release'>

	| vpaned |
	classHierarchyUpdate := false.
	undoStack := (UndoStack new)
			initialize;
			yourself.
	vpaned := GTK.GtkVPaned new.
	self mainWidget: vpaned.
    
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

    undo [
	<category: 'edit events'>

	undoStack undo
    ]

    redo [
	<category: 'edit events'>

	undoStack redo
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
 
    newNamespace [
	<category: 'namespace events'>

	| dlg name namespace |
	namespaceWidget hasSelectedNamespace ifFalse: [ ^ self ].
	dlg := GtkEntryDialog title: 'Add a namespace' text: 'Name of the new namespace'.
	dlg hasPressedOk ifTrue: [ name := dlg result.
	    namespace := namespaceWidget selectedNamespace.
	    undoStack push: (AddNamespaceCommand add: name asSymbol to: namespace onModel: GtkNamespaceModel current) ]
    ]

    renameNamespace [
	<category: 'namespace events'>

        | dlg name namespace |
        namespaceWidget hasSelectedNamespace ifFalse: [ ^ self ].
        dlg := GtkEntryDialog title: 'Rename a namespace' text: 'Name of the new namespace'.
        dlg hasPressedOk ifTrue: [ name := dlg result.
            namespace := namespaceWidget selectedNamespace.
            undoStack push: (RenameNamespaceCommand rename: namespace as: name asSymbol onModel: GtkNamespaceModel current) ]
    ]

    deleteNamespace [
	<category: 'namespace events'>

        | namespace |
        namespaceWidget hasSelectedNamespace ifFalse: [ ^ self ].
        namespace := namespaceWidget selectedNamespace.
	namespace subspaces isEmpty ifFalse: [ self error: 'Namespace has subspaces' ].
        undoStack push: (DeleteNamespaceCommand delete: namespace onModel: GtkNamespaceModel current) 
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

    newClass [
	<category: 'class events'>
	
	| dlg name namespace superclass |
        namespaceWidget hasSelectedNamespace ifFalse: [ ^ self ].
	namespace := namespaceWidget selectedNamespace.
	classWidget hasSelectedClass
	    ifTrue: [ superclass := classWidget selectedClass ]
	    ifFalse: [ superclass := Object ].
        dlg := GtkEntryDialog title: 'Add a class' text: 'Name of the new class'.
        dlg hasPressedOk ifTrue: [ name := dlg result.
            namespace := namespaceWidget selectedNamespace.
            undoStack push: (AddClassCommand add: name asSymbol to: namespace onModel: (GtkClassModel currentOn: namespace) withSuperclass: superclass) ]
    ]

    renameClass [
	<category: 'class events'>

        | dlg name namespace class |
	namespaceWidget hasSelectedNamespace ifFalse: [ ^ self ].
        namespace := namespaceWidget selectedNamespace.
        classWidget hasSelectedClass ifFalse: [ ^ self ].
        class := classWidget selectedClass.
        dlg := GtkEntryDialog title: 'Rename a class' text: 'Name of the class'.
        dlg hasPressedOk ifTrue: [ name := dlg result.
            undoStack push: (RenameClassCommand rename: class as: name asSymbol onModel: (GtkClassModel currentOn: namespace)) ]
    ]

    deleteClass [
	<category: 'class events'>

        | dlg name namespace class |
	namespaceWidget hasSelectedNamespace ifFalse: [ ^ self ].
        namespace := namespaceWidget selectedNamespace.
        classWidget hasSelectedClass ifFalse: [ ^ self ].
        class := classWidget selectedClass.
	class subclasses isEmpty ifFalse: [ self error: 'class has subclasses' ].
        undoStack push: (DeleteClassCommand delete: class onModel: (GtkClassModel currentOn: namespace))
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

    newCategory [
        <category: 'category events'>

	| categoryModel dlg name |
	classWidget hasSelectedClass ifFalse: [ ^ self ].
	dlg := GtkEntryDialog title: 'Add a category' text: 'Name of the category'.
	categoryModel := self viewedCategoryModel.
        dlg hasPressedOk ifTrue: [ name := dlg result.
            undoStack push: (AddCategoryCommand add: name onModel: categoryModel) ]
    ]

    renameCategory [
        <category: 'category events'>

	| categoryWidget categoryModel dlg name |
	classWidget hasSelectedClass ifFalse: [ ^ self ].
	categoryWidget := self viewedCategoryWidget.
	categoryWidget hasSelectedCategory ifFalse: [ ^ self ].
	dlg := GtkEntryDialog title: 'Rename a category' text: 'Name of the category'.
	categoryModel := self viewedCategoryModel.
        dlg hasPressedOk ifTrue: [ name := dlg result.
            undoStack push: (RenameCategoryCommand rename: categoryWidget selectedCategory in: self classOrMetaSelected as: name onModel: categoryModel) ]
    ]

    deleteCategory [
        <category: 'category events'>

        | categoryWidget categoryModel |
	classWidget hasSelectedClass ifFalse: [ ^ self ].
	categoryWidget := self viewedCategoryWidget.
        categoryWidget hasSelectedCategory ifFalse: [ ^ self ].
        categoryModel := self viewedCategoryModel.
        undoStack push: (DeleteCategoryCommand delete: categoryWidget selectedCategory in: self classOrMetaSelected onModel: categoryModel)
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

    newMethod [
	<category: 'method events'>

	| category categoryWidget methodModel |
	classWidget hasSelectedClass ifFalse: [ ^ self ].
	categoryWidget := self viewedCategoryWidget.
	methodModel := self viewedMethodModel.
	category := categoryWidget hasSelectedCategory 
			ifFalse: [ nil ]
			ifTrue: [ categoryWidget selectedCategory ].
	undoStack push: (AddMethodCommand add: codeWidget sourceCode classified: category in: self classOrMetaSelected onModel: methodModel)
    ]


    deleteMethod [
	<category: 'method events'>

	| methodModel methodWidget |
	classWidget hasSelectedClass ifFalse: [ ^ self ].
	methodWidget := self viewedMethodWidget.
	methodWidget hasSelectedMethod ifFalse: [ ^ self ].
	methodModel := self viewedMethodModel.
	undoStack push: (DeleteMethodCommand delete: methodWidget selectedMethodSymbol in: self classOrMetaSelected onModel: methodModel)
    ]

    inspectMethod [
	<category: 'method events'>

	| methodWidget |
	classWidget hasSelectedClass ifFalse: [ ^ self ].
	methodWidget := self viewedMethodWidget.
        GtkInspector openOn: methodWidget selectedMethod
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
]

