GtkTextWidget subclass: GtkSourceCodeWidget [
    | browser codeText codeView object |

    initialize [
	<category: 'initialization'>

	super initialize.
	self initializeHighlighter
    ]

    initializeHighlighter [
	<category: 'initialization'>

	(textWidget getBuffer)
	    createTag: #classVar varargs: #('foreground' 'cyan4' nil);
	    createTag: #globalVar varargs: #('foreground' 'cyan4' nil);
	    createTag: #poolVar varargs: #('foreground' 'cyan4' nil);
	    createTag: #undeclaredVar varargs: #('foreground' 'red' nil);
	    createTag: #instanceVar varargs: #('foreground' 'black' nil);
	    createTag: #argumentVar varargs: #('foreground' 'black' nil);
	    createTag: #temporary varargs: #('foreground' 'black' nil);
	    createTag: #specialId varargs: #('foreground' 'grey50' nil);
	    createTag: #literal varargs: #('foreground' 'grey50' nil);
	    createTag: #temporaries varargs: #('foreground' 'magenta' nil);
	    createTag: #methodHeader varargs: #('foreground' 'magenta' nil);
	    createTag: #primitive varargs: #('foreground' 'magenta' nil);
	    createTag: #arguments varargs: #('foreground' 'magenta' nil);
	    createTag: #special varargs: #('foreground' 'magenta' nil);
	    createTag: #unaryMsg varargs: #('foreground' 'magenta4' nil);
	    createTag: #binaryMsg varargs: #('foreground' 'chocolate4' nil);
	    createTag: #keywordMsg varargs: #('foreground' 'NavyBlue' nil);
	    createTag: #comment varargs: #('foreground' 'SpringGreen4' nil)
    ]

    popupMenuOn: aGtkWidget menu: aGtkMenu [
        <category: 'events'>

        | menuitem symbol |

	symbol := self selectedMethodSymbol.
        menuitem := GTK.GtkMenuItem new.
        menuitem show.
        aGtkMenu append: menuitem.
        menuitem := GTK.GtkMenuItem newWithLabel: 'Browse senders'.
        menuitem
	    setSensitive: symbol notNil;
            show;
            connectSignal: 'activate' to: self selector: #browseSenders userData: nil.
        aGtkMenu append: menuitem.
        menuitem := GTK.GtkMenuItem newWithLabel: 'Browse implementors'.
        menuitem
	    setSensitive: symbol notNil;
            show;
            connectSignal: 'activate' to: self selector: #browseImplementors userData: nil.
        aGtkMenu append: menuitem.
        menuitem := GTK.GtkMenuItem new.
        menuitem show.
        menuitem := GTK.GtkMenuItem new.
        menuitem show.
        aGtkMenu append: menuitem.
        menuitem := GTK.GtkMenuItem newWithLabel: 'Accept'.
        menuitem
            show;
            connectSignal: 'activate' to: self selector: #accept userData: nil.
        aGtkMenu append: menuitem.
        menuitem := GTK.GtkMenuItem newWithLabel: 'Cancel'.
        menuitem
            show;
            connectSignal: 'activate' to: self selector: #cancel userData: nil.
        aGtkMenu append: menuitem.
        menuitem := GTK.GtkMenuItem new.
        menuitem show.
        aGtkMenu append: menuitem.
        menuitem := GTK.GtkMenuItem newWithLabel: 'Undo'.
        menuitem
            show;
            connectSignal: 'activate' to: self selector: #undo userData: nil.
        aGtkMenu append: menuitem.
        menuitem := GTK.GtkMenuItem newWithLabel: 'Redo'.
        menuitem
            show;
            connectSignal: 'activate' to: self selector: #redo userData: nil.
        aGtkMenu append: menuitem.
        menuitem := GTK.GtkMenuItem newWithLabel: 'Do It'.
        menuitem
            show;
            connectSignal: 'activate' to: self selector: #doIt userData: nil.
        aGtkMenu append: menuitem.
        menuitem := GTK.GtkMenuItem newWithLabel: 'Print It'.
        menuitem
            show;
            connectSignal: 'activate' to: self selector: #printIt userData: nil.
        aGtkMenu append: menuitem.
        menuitem := GTK.GtkMenuItem newWithLabel: 'Inspect It'.
        menuitem
            show;
            connectSignal: 'activate' to: self selector: #inspectIt userData: nil.
        aGtkMenu append: menuitem.
        menuitem := GTK.GtkMenuItem newWithLabel: 'Debug It'.
        menuitem
            show;
            connectSignal: 'activate' to: self selector: #debugIt userData: nil.
        aGtkMenu append: menuitem
    ]

    sourceCode [
	<category: 'accessing'>

	^ textWidget getBuffer text
    ]

    namespaceDefinition: aString [
	<category: 'accessing'>

	textWidget emptyStack.
	self codeText: aString. 
	textWidget getBuffer setText: aString
    ]

    classDefinition: aString [
	<category: 'accessing'>

	textWidget emptyStack.
	self codeText: aString. 
	textWidget getBuffer setText: aString
    ]

    clearCode [
	<category: 'accessing'>

	textWidget getBuffer setText: ''
    ]

    sourceCode: aString [
	<category: 'accessing'>

	textWidget emptyStack.
	self codeText: aString. 
	textWidget getBuffer setText: aString.
	self parseSource: aString ifParsed: [ :node | SyntaxHighlighter highlight: node in: textWidget getBuffer ]
    ]

    parseSource: aString ifParsed: aOneArgBlock [
	<category: 'parsing'>

	| node parser |
	parser := STInST.RBBracketedMethodParser new
                    errorBlock: [ :string :pos | ^ self ];
                    initializeParserWith: aString type: #'on:errorBlock:';
                    yourself.
        [ node := parser parseMethod ] on: Error do: [ :ex | stderr print: ex messageText; nl; print: ex signalingContext; nl; nl. ^ self ].
	^ aOneArgBlock value: node
    ]

    connectSignals [
        <category: 'initialization'>

	super connectSignals.
        (textWidget getBuffer)
	    connectSignal: 'changed' to: self selector: #'changed' userData: nil
    ]

    buildWidget [
	<category: 'user interface'>
	
        "codeView := ((textWidget := GtkTextWidget new) 
			initialize;
			textWidget)
			connectSignal: 'populate-popup' to: self selector: #'popupMenuOn:menu:' userData: nil;
			yourself.

	codeBuffer := textWidget buffer.

	codeBuffer 
	    connectSignal: 'changed' to: self selector: #'changed' userData: nil."

        ^ (GTK.GtkFrame new: 'Code')
            add: super buildWidget;
            yourself
    ]

    changed [
	<category: 'buffer changed'>

	| node text |
	(text := textWidget getBuffer text) = '' ifTrue: [ ^ self ].
	self parseSource: text ifParsed: [ :node | SyntaxHighlighter highlight: node in: textWidget getBuffer ]
    ]

    hasUndo [
	<category: 'testing'>

	^ codeView hasUndo
    ]

    hasChanged [
	<category: 'testing'>

	^ textWidget hasChanged
    ]

    clearUndo [
	<category: 'buffer events'>

	textWidget clearUndo
    ]

    accept [
	<category: 'buffer events'>

	browser acceptIt
    ]

    cancel [
	<category: 'buffer events'>

	self clearUndo.
	textWidget getBuffer setText: self codeText
    ]

    undo [
	<category: 'buffer events'>

	textWidget undo
    ]

    redo [
	<category: 'buffer events'>

	textWidget redo
    ]

    object: anObject [
	<category: 'accessing'>

	object := anObject
    ]

    doIt [
        <category: 'smalltalk event'>

	^ Behavior
            evaluate: textWidget getBuffer selectedText 
            to: object
            ifError: [ :fname :lineNo :errorString | self error: errorString ]
    ]


    debugIt [
        <category: 'smalltalk event'>

	object class
            compile: ('Doit [ ^ [ ', self selectedText , ' ] value ]')
            ifError:  [ :fname :lineNo :errorString |
                self error: errorString ].
        (GtkDebugger open)
            doItProcess: [ object perform: #Doit ] newProcess
    ]


    inspectIt [
        <category: 'smalltalk event'>

	GtkInspector openOn: self doIt
    ]


    printIt [
        <category: 'smalltalk event'>

	| iter start end result |
        iter := textWidget getBuffer iterOfSelectedText second.
        result := ' ', (self doIt displayString), ' '.
        textWidget getBuffer insertInteractive: iter text: result len: result size defaultEditable: true.
        start := textWidget getBuffer getIterAtOffset: (iter getOffset - result size).
        end := textWidget getBuffer getIterAtOffset: (iter getOffset).
        textWidget getBuffer selectRange: start bound: end
    ]

    copy [
        <category: 'text editing'>

        codeView signalEmitByName: 'copy-clipboard' args: {}
    ]

    cut [
        <category: 'text editing'>

        codeView signalEmitByName: 'cut-clipboard' args: {}
    ]

    paste [
        <category: 'text editing'>

        codeView signalEmitByName: 'paste-clipboard' args: {}.
    ]

    selectAll [
        <category: 'text editing'>

        codeView signalEmitByName: 'select-all' args: {true}.
    ]

    selectedText [
        <category: 'text accessing'>

        ^ codeView getBuffer selectedText
    ]

    textview [
	<category: 'accessing'>

	^ codeView
    ]

    codeSaved [
	<category: 'accessing'>

	codeView textSaved
    ]

    codeText [
	<category: 'accessing'>

	^ codeText ifNil: [ codeText := '' ]
    ]

    codeText: aString [
	<category: 'accessing'>

	codeText := aString copy
    ]

    browser: aGtkClassBrowserWidget [
	<category: 'accessing'>

	browser := aGtkClassBrowserWidget
    ]

    selectedMethodSymbol [
        | iters stream parser node |
	stream := self sourceCode readStream.
        iters := textWidget getBuffer getSelectionBounds.
        parser := STInST.RBBracketedMethodParser new.
        parser errorBlock: [:message :position | ^nil].
        parser 
            scanner: (parser scannerClass on: stream errorBlock: parser errorBlock).
        node := parser parseMethod body.
        node := node bestNodeFor:
	    (iters first getOffset + 1 to: iters second getOffset + 1).
        [node isNil ifTrue: [^nil].
	node isMessage] whileFalse: 
                [node := node parent].
        ^node selector
    ]

    browseSenders [
	<category: 'browse'>

	OpenSenderCommand on: self
    ]

    browseImplementors [
	<category: 'browse'>

	OpenImplementorCommand on: self
    ]

    appendTag: aSymbol description: anArray [
	<category: 'text buffer'>

	textWidget getBuffer
            createTag: aSymbol varargs: anArray
    ]

    applyTag: aSymbol forLine: anInteger [
	<category: 'text buffer'>

	| start end |
	start := textWidget getBuffer getIterAtLine: anInteger - 1.
	end := textWidget getBuffer getIterAtLine: anInteger.
	textWidget getBuffer applyTagByName: aSymbol start: start end: end
    ]
]

