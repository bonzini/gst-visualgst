GtkConcreteWidget subclass: GtkSourceCodeWidget [
    | codeBuffer codeView userAction undoStack lastCommand |

    initialize [
	<category: 'initialization'>

	userAction := false.
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

    sourceCode [
	<category: 'accessing'>

	^ codeBuffer text
    ]

    namespaceDefinition: aString [
	<category: 'accessing'>

	codeBuffer setText: aString
    ]

    classDefinition: aString [
	<category: 'accessing'>

	codeBuffer setText: aString
    ]

    clearCode [
	<category: 'accessing'>

	codeBuffer setText: ''
    ]

    sourceCode: aString [
	<category: 'accessing'>

	| node |
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

        codeView := GTK.GtkTextView new.
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

    insert: aGtkTextBuffer at: aCObject text: aString size: anInteger [
	<category: 'buffer events'>

	| gtkTextIter offset |
	userAction ifFalse: [ ^ self ].
	gtkTextIter := GTK.GtkTextIter address: aCObject address.
	lastCommand ifNil: [ lastCommand := InsertTextCommand insert: aString at: gtkTextIter getOffset.
	    ^ self ].
	(gtkTextIter getOffset = (lastCommand offset + lastCommand size))
	    ifTrue: [ lastCommand string: (lastCommand string, aString).
		^ self ].
	undoStack push: lastCommand.
	lastCommand := InsertTextCommand insert: aString at: gtkTextIter getOffset
    ]

    delete: aGtkTextBuffer from: aStartCObject to: anEndCObject [
	<category: 'buffer events'>

	| startIter endIter |
	userAction ifFalse: [ ^ self ].
	startIter := GTK.GtkTextIter address: aStartCObject address.
	endIter := GTK.GtkTextIter address: anEndCObject address.
    ]
]

