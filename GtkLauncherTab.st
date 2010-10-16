GtkConcreteWidget subclass: GtkLauncherTab [
    | shell checkCode historyStack state updating |

    "TODO: many abstract methods are probably missing"

    shell: aGtkLauncher [
        <category: 'accessing'>

        shell := aGtkLauncher
    ]
    
    shell [
	<category: 'accessing'>

	^ shell
    ]

    buildMainWidget [
	<category: 'initialize-release'>

        self subclassResponsibility
    ]

    initialize [
	<category: 'initialize-release'>

	historyStack := HistoryStack new.
	checkCode := true.
        updating := false.
        self mainWidget: self buildMainWidget
    ]

    postInitialize [
	<category: 'initialize'>

    ]

    historyStack [
	<category: 'history'>

        ^historyStack
    ]

    grabFocus [
	<category: 'user interface'>

    ]

    undoStack [
	<category: 'accessings'>

	^ shell undoStack
    ]

    undo [
	<category: 'edit events'>

	self undoStack undo
    ]

    redo [
	<category: 'edit events'>

        self undoStack redo
    ]

    selectNamespaceState: aState [
	<category: 'private-selection'>

    ]

    acceptNamespaceState: aState [
	<category: 'private-selection'>
    ]

    finishNamespaceState [
	<category: 'private-selection'>
    ]

    selectClassState: aState [
	<category: 'selection'>
    ]

    acceptClassState: aState [
	<category: 'selection'>
    ]

    finishClassState [
	<category: 'selection'>
    ]

    selectCategoryState: aState [
	<category: 'selection'>
    ]

    acceptCategoryState: aState [
	<category: 'selection'>
    ]

    finishCategoryState [
	<category: 'selection'>
    ]

    selectMethodState: aState [
	<category: 'selection'>
    ]

    acceptMethodState: aState [
	<category: 'selection'>
    ]

    finishMethodState [
	<category: 'selection'>
    ]

    selectANamespace: aNamespace [
	<category: 'private-selection'>
        ^self updateState: (NamespaceState with: aNamespace)
    ]

    selectAClass: aClass [
	<category: 'private-selection'>
        ^self updateState: (ClassState with: aClass)
    ]

    selectAnInstanceMethod: aSelector [
        <category: 'selection'>

	self updateState: (MethodState state: self state classOrMeta asClass >> aSelector)
    ]

    selectAClassMethod: aSelector [
	<category: 'selection'>

	self updateState: (MethodState state: self state classOrMeta asMetaclass >> aSelector)
    ]

    targetObject [
        <category: 'target'>

        ^ self state classOrMeta
    ]

    forward [
	<category: 'history events'>

        self updateState: historyStack next
            onCancel: [ historyStack previous].
    ]

    back [
	<category: 'history events'>

        self updateState: historyStack previous
            onCancel: [ historyStack next].
    ]

    sourceCodeWidgetHasFocus [
	<category: 'testing'>

	self subclassResponsibility
    ]
 
    hasSelection [
	<category:'text testing'>

	self subclassResponsibility
    ]
 
    selectedMethodSymbol [
        <category: 'text editing'>

	self subclassResponsibility
    ]

    selectedText [
	<category: 'text editing'>

	self subclassResponsibility
    ]

    doNotCheckCode [
	<category: 'text editing'>

	checkCode := false
    ]

    dropAndEvaluate: aBlock [
        "FIXME: is this #clearUndo necessary?"
        self clearUndo.
        ^aBlock value
    ]

    cancelAndEvaluate: aBlock [
	<category: 'accessing'>
        | result |
        result := aBlock value.
        self whileFrozenDo: [ self selectState ].
        ^result
    ]

    whileFrozenDo: aBlock [
	<category: 'accessing'>
        ^aBlock value.
    ]

    checkCodeWidgetAndUpdate: aBlock [
        <category: 'text editing'>

        self checkCodeWidgetAndUpdate: aBlock onCancel: []
    ]

    checkCodeWidgetAndUpdate: aBlock onCancel: cancelBlock [
        <category: 'saving'>

        | dialog |
        checkCode ifFalse: [ checkCode := true. ^self dropAndEvaluate: aBlock ].
        self hasChanged ifFalse: [ ^self dropAndEvaluate: aBlock ].
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
                res = 0 ifTrue: [ self codeSaved ].
                res = 1 ifTrue: [ self acceptIt ].
                (res <= 1 and: [ self hasChanged not ])
                    ifTrue: [ self dropAndEvaluate: aBlock ]
                    ifFalse: [ self cancelAndEvaluate: cancelBlock ].
                dlg destroy ].
    ]

    codeSaved [
	<category: 'saving'>

    ]

    state [
	<category: 'accessing'>

	^ state
    ]

    updateState: newState onCancel: aBlock [
	<category: 'accessing'>
        updating ifTrue: [^self].
        newState isNil ifTrue: [^self].
        self checkCodeWidgetAndUpdate: [ self state: newState ] onCancel: aBlock
    ]

    updateState: newState [
	<category: 'accessing'>
        self updateState: newState onCancel: []
    ]

    selectState [
	<category: 'accessing'>

        | saveUpdating |
        saveUpdating := updating.
        updating := true.
        state selectInBrowser: self.
        shell isNil ifFalse: [ shell historyChanged ].
        updating := saveUpdating.
    ]

    state: aState [
	<category: 'accessing'>

        self state = aState ifTrue: [^self].
        state := aState.
        historyStack push: aState.
        self selectState.
    ]

    close [
	<category: 'user interface'>

        "is this right?"
	self checkCodeWidgetAndUpdate: []
    ]
]

