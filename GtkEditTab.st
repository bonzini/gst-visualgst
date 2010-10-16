GtkLauncherTab subclass: GtkEditTab [
    | codeWidget |

    buildCodeView: aClass [
	<category: 'user interface'>

	codeWidget := aClass showAll 
			parentWindow: self parentWindow;
			browser: self;
			yourself.
    
	^ codeWidget mainWidget
    ]

    postInitialize [
	<category: 'initialize'>

	super postInitialize.
	codeWidget postInitialize
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

    sourceCode [
	<category: 'accessing'>

	^ codeWidget sourceCode
    ]

    compileError: aString line: line [
        <category: 'method events'>

        codeWidget compileError: aString line: line
    ]

    clearSource [
	<category: 'private-selection'>

	codeWidget clear
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

    whileFrozenDo: aBlock [
	<category: 'accessing'>
        codeWidget whileFrozenDo: [ super whileFrozenDo: aBlock ].
    ]
]

