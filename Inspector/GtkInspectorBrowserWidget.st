GtkConcreteWidget subclass: GtkInspectorBrowserWidget [
    | namespaceWidget classWidget classHierarchyWidget classHierarchyUpdate iCategoryWidget iMethodWidget cCategoryWidget cMethodWidget codeWidget |

    GtkInspectorBrowserWidget class >> title [
	<category: 'accessing'>

	^ 'Gtk class browser'
    ]

    buildBrowser [

	^ GTK.GtkHPaned new
	    pack1: self buildHierarchy resize: true shrink: false;
	    pack2: self buildProtocolAndMethod resize: true shrink: false;
	    showAll;
	    yourself
    ]

    buildClassBrowser [

	^ GTK.GtkHPaned new
            pack1: self buildClassMethodView resize: true shrink: false;
	    showAll;
	    yourself
    ]

    buildInstanceBrowser [

	^ GTK.GtkHPaned new
	    pack1: self buildInstanceMethodView resize: true shrink: false;
	    showAll;
	    yourself
    ]

    buildProtocolAndMethod [

	^  (GTK.GtkNotebook new)
	    appendPage: self buildInstanceBrowser tabLabel: (GTK.GtkLabel new: 'Instance');
	    appendPage: self buildClassBrowser tabLabel: (GTK.GtkLabel new: 'Class');
	    showAll;
	    setCurrentPage: 0;
	    connectSignal: 'switch-page' to: self selector: #'classInstanceSwitchOn:page:number:' userData: nil;
	    yourself
    ]

    buildCodeView [
	<category: 'user interface'>

	codeWidget := (GtkSourceCodeWidget new)
			parentWindow: self parentWindow;
			initialize;
			browser: self;
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
	vpaned := GTK.GtkVPaned new.
	self mainWidget: vpaned.
    
	vpaned
	    pack1: self buildBrowser resize: true shrink: false;
	    pack2: self buildCodeView resize: true shrink: true ;
	    showAll
    ]

    classInstanceSwitchOn: aGtkNotebook page: aGtkNotebookPage number: aSmallInteger [
	<category: 'events'>

	aSmallInteger = 0 
	    ifTrue: [
		iMethodWidget hasSelectedMethod 
		    ifTrue: [ codeWidget sourceCode: iMethodWidget sourceCode ]
		    ifFalse: [ codeWidget sourceCode: '' ] ]
	    ifFalse: [
                cMethodWidget hasSelectedMethod
                    ifTrue: [ codeWidget sourceCode: cMethodWidget sourceCode ]
                    ifFalse: [ codeWidget sourceCode: '' ] ]
    ]

    onClassHierarchyChanged [
	<category: 'events'>

	| aClass |
	classHierarchyWidget hasSelectedClass ifFalse: [ ^ self ].
	classHierarchyUpdate := true.
        aClass := classHierarchyWidget selectedClass.

        iMethodWidget class: aClass withCategory: '*'.
        cMethodWidget class: aClass class withCategory: '*'.

        codeWidget sourceCode: ''
    ]

    onInstanceSideCategoryChanged [
	<category: 'events'>

	| category |
	iCategoryWidget hasSelectedCategory ifFalse: [ ^ self ].
	iMethodWidget class: classWidget selectedClass withCategory: iCategoryWidget selectedCategory.

	codeWidget sourceCode: ''
    ]

    onClassSideCategoryChanged [
	<category: 'events'>
	
	cCategoryWidget hasSelectedCategory ifFalse: [ ^ self ].
	cMethodWidget class: classWidget selectedClass class withCategory: cCategoryWidget selectedCategory.

	codeWidget sourceCode: ''
    ]

    onInstanceSideMethodChanged [
	<category: 'events'>

	| method |
	self checkCodeWidget.
	iMethodWidget hasSelectedMethod ifFalse: [ ^ self ].
	method := iMethodWidget selectedMethod.
	codeWidget sourceCode: iMethodWidget sourceCode
    ]

    onClassSideMethodChanged [
	<category: 'events'>

	| method |
	self checkCodeWidget.
	cMethodWidget hasSelectedMethod ifFalse: [ ^ self ].
	method := cMethodWidget selectedMethod.
	codeWidget sourceCode: cMethodWidget sourceCode
    ]

    selectAClass: aClass [
	<category: 'selection'>

	classHierarchyWidget class: aClass.

	iMethodWidget class: aClass withCategory: '*'.
	cMethodWidget class: aClass class withCategory: '*'.
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

    cancel [
        <category: 'buffer events'>

	codeWidget hasFocus ifTrue: [ codeWidget cancel ]
    ]

    undo [
        <category: 'buffer events'>

	codeWidget hasFocus ifTrue: [ codeWidget undo ]
    ]

    redo [
        <category: 'buffer events'>

	codeWidget hasFocus ifTrue: [ codeWidget redo ]
    ]

    copy [
        <category: 'text editing'>

	codeWidget hasFocus ifTrue: [ codeWidget copy ]
    ]

    cut [
        <category: 'text editing'>

	codeWidget hasFocus ifTrue: [ codeWidget cut ]
    ]

    paste [
        <category: 'text editing'>

	codeWidget hasFocus ifTrue: [ codeWidget paste ]
    ]

    selectAll [
        <category: 'text editing'>

	codeWidget hasFocus ifTrue: [ codeWidget selectAll ]
    ]

    checkCodeWidget [
        <category: 'text editing'>

        | dlg |
        codeWidget hasChanged ifFalse: [ codeWidget clearUndo. ^ self ].
        dlg := GTK.GtkMessageDialog
                    new: parentWindow
                    flags: GTK.Gtk gtkDialogDestroyWithParent
                    type: GTK.Gtk gtkMessageWarning
                    buttons: GTK.Gtk gtkButtonsOkCancel
                    message: 'Do you want to save the text buffer'.
        dlg runBlockingAndDo: [ :dlg :res |
            res = GTK.Gtk gtkResponseOk ifTrue: [ "saveSource" ].
            dlg destroy ].
        codeWidget clearUndo
    ]
]

