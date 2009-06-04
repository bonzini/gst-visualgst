GtkConcreteWidget subclass: GtkSourceCodeWidget [
    | codeBuffer codeView userAction undoStack lastCommand paste cut |

    initialize [
	<category: 'initialization'>

	cut := paste := userAction := false.
	undoStack := (UndoStack new)
			initialize;
			yourself.
	self mainWidget: self buildCodeView.
	self initializeHighlighter
    ]

    initializeHighlighter [
	<category: 'initialization'>

	codeBuffer 
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

        | menuitem |

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

	^ codeBuffer text
    ]

    namespaceDefinition: aString [
	<category: 'accessing'>

	undoStack clear.
	codeBuffer setText: aString
    ]

    classDefinition: aString [
	<category: 'accessing'>

	undoStack clear.
	codeBuffer setText: aString
    ]

    clearCode [
	<category: 'accessing'>

	codeBuffer setText: ''
    ]

    sourceCode: aString [
	<category: 'accessing'>

	| node |
	undoStack clear.
	codeBuffer setText: aString.
	node := self parseSource: aString.
	SyntaxHighlighter highlight: node in: codeBuffer
    ]

    parseSource: aString [
	<category: 'parsing'>

	| parser |
	parser := STInST.RBBracketedMethodParser new
                    errorBlock: [ :string :pos | ^ self ];
                    initializeParserWith: aString type: #'on:errorBlock:';
                    yourself.
        ^ parser parseMethod
    ]

    buildCodeView [
	<category: 'user interface'>

        codeView := (GTK.GtkTextView new)
			connectSignal: 'populate-popup' to: self selector: #'popupMenuOn:menu:' userData: nil;
			connectSignal: 'paste-clipboard' to: self selector: #paste userData: nil;
			connectSignal: 'cut-clipboard' to: self selector: #cut userData: nil;
			yourself.
	codeBuffer := codeView getBuffer.

	codeBuffer 
	    connectSignal: 'changed' to: self selector: #'changed' userData: nil;
	    connectSignal: 'begin-user-action' to: self selector: #'beginUserAction' userData: nil;
	    connectSignal: 'end-user-action' to: self selector: #'endUserAction' userData: nil;
	    connectSignal: 'insert-text' to: self selector: #'insert:at:text:size:' userData: nil;
	    connectSignal: 'delete-range' to: self selector: #'delete:from:to:' userData: nil.

        ^ (GTK.GtkFrame new: 'Code')
            add: (GTK.GtkScrolledWindow withChild: codeView);
            yourself
    ]

    changed [
	<category: 'buffer changed'>

	| node text |
	(text := codeBuffer text) = '' ifTrue: [ ^ self ].
	node := self parseSource: text.
	node == self ifTrue: [ ^ self ].
        SyntaxHighlighter highlight: node in: codeBuffer
    ]

    beginUserAction [
	<category: 'buffer events'>

	userAction := true
    ]

    endUserAction [
	<category: 'buffer events'>

	userAction := false
    ]

    paste [
        <category: 'clipboard events'>

	lastCommand := nil
    ]

    cut [
	<category: 'clipboard events'>

	cut := true and: [ codeBuffer getHasSelection ].
	cut ifTrue: [ lastCommand := nil ]
    ]

    insert: aGtkTextBuffer at: aCObject text: aString size: anInteger [
	<category: 'buffer events'>

	| gtkTextIter offset |
	userAction ifFalse: [ ^ self ].
	gtkTextIter := GTK.GtkTextIter address: aCObject address.
	(lastCommand isNil or: [ aString size > 1 ]) 
	    ifTrue: [ lastCommand := InsertTextCommand insert: aString at: gtkTextIter getOffset on: codeBuffer.
		undoStack push: lastCommand.
		aString size > 1 ifTrue: [ lastCommand := nil ].
		^ self ].
	((gtkTextIter getOffset = (lastCommand offset + lastCommand size)) and: [ lastCommand isInsertCommand ])
	    ifTrue: [ lastCommand string: (lastCommand string, aString).
		^ self ].
	lastCommand := InsertTextCommand insert: aString at: gtkTextIter getOffset on: codeBuffer.
	undoStack push: lastCommand.
    ]

    delete: aGtkTextBuffer from: aStartCObject to: anEndCObject [
	<category: 'buffer events'>

	| startIter endIter text |
	userAction ifFalse: [ cut := false. ^ self ].
	startIter := GTK.GtkTextIter address: aStartCObject address.
	endIter := GTK.GtkTextIter address: anEndCObject address.
	text := codeBuffer getText: startIter end: endIter includeHiddenChars: false.
        (lastCommand isNil or: [ cut ])
	    ifTrue: [ lastCommand := DeleteTextCommand from: startIter getOffset to: endIter getOffset text: text on: codeBuffer.
		undoStack push: lastCommand.
		cut ifTrue: [ lastCommand := nil ].
		cut := false.
		^ self ].
	((startIter getOffset = (lastCommand offset - lastCommand size)) and: [ lastCommand isDeleteCommand ])
            ifTrue: [ lastCommand string: (text, lastCommand string).
                ^ self ].
        lastCommand := DeleteTextCommand from: startIter getOffset to: endIter getOffset text: text on: codeBuffer.
        undoStack push: lastCommand.
    ]

    undo [
	<category: 'buffer events'>

	undoStack undo.
	lastCommand := nil.
    ]

    redo [
	<category: 'buffer events'>

	undoStack redo.
	lastCommand := nil.
    ]
]

