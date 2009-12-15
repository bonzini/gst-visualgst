Command subclass: OpenBrowserCommand [

    extractNamespaceAndClassFrom: aString [
	<category: 'parsing'>

	| node token start |
	node := STInST.RBParser parseExpression: aString.
	node isVariable ifFalse: [ ^ Smalltalk->Object ].
	token := node name tokenize: '\.'.
	token size = 1 ifTrue: [ | result |
		result := Smalltalk at: token first asSymbol ifAbsent: [ ^ Smalltalk -> Object ].
		result isClass ifTrue: [ ^ Smalltalk -> result ].
		result isNamespace ifTrue: [ ^ result -> nil ].
		^ Smalltalk -> Object ].
	start := Smalltalk.
	token do: [ :each |
	    start printNl.
	    each printNl.
	    start := start at: each asSymbol ifAbsent: [ ^ Smalltalk -> Object ] ].
	start isClass 
		ifTrue: [ ^ start environment -> start ].
	start isNamespace ifTrue:  [ ^ start -> nil ].
	^ Smalltalk -> Object
    ]

    extractSelectedItems [
	<category: ''>

	| result |
	VisualGST uniqueInstance currentWidgetOfBrowser hasSelectedClass
                ifTrue: [ result := VisualGST uniqueInstance currentWidgetOfBrowser selectedNamespace -> VisualGST uniqueInstance currentWidgetOfBrowser selectedClass ]
                ifFalse: [ VisualGST uniqueInstance currentWidgetOfBrowser hasSelectedNamespace 
				    ifTrue: [ result := VisualGST uniqueInstance currentWidgetOfBrowser selectedNamespace -> nil ]
				    ifFalse: [ result := Smalltalk -> Object ] ].
	^ result 
    ]

    extractFromSelection [
	<category: ''>

	| result selection |
	(selection := VisualGST uniqueInstance onFocusPerform: #selectedText)
                ifNotNil: [ result := self extractNamespaceAndClassFrom: selection ]
                ifNil: [ result := Smalltalk->Object ].
	^ result
    ]

    buildBrowserAndSelect: anAssociation [
	<category: 'user interface'>

	| browser |
        browser := VisualGST uniqueInstance classBrowser.
        browser selectANamespace: anAssociation key.
        anAssociation value ifNotNil: [ browser selectAClass: anAssociation value ].
    ]

    execute [
        <category: 'command'>

	| node selection result |
	VisualGST uniqueInstance browserHasFocus 
		    ifTrue: [
			(VisualGST uniqueInstance currentWidgetOfBrowser sourceCodeWidgetHasFocus and: [ VisualGST uniqueInstance currentWidgetOfBrowser selectedText isNil not ]) 
							    ifTrue: [ result := self extractNamespaceAndClassFrom: VisualGST uniqueInstance currentWidgetOfBrowser selectedText ]
							    ifFalse: [ result := self extractSelectedItems ] ]
		    ifFalse: [ result := self extractFromSelection ].
	self buildBrowserAndSelect: result.
    ]
]

