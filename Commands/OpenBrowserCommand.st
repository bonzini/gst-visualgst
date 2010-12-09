Command subclass: OpenBrowserCommand [

    defaultDestination [
	<category: 'parsing'>

        ^NamespaceState with: Smalltalk
    ]

    namespace [
        ^ target state namespace ifNil: [ Smalltalk ]
    ]

    computeStateFrom: aString [
	<category: 'parsing'>

	| node token start |
	[ node := STInST.RBParser parseExpression: aString ] on: Error do: [ ^ self defaultDestination ].
	node isVariable ifFalse: [ ^ self defaultDestination ].

        start := self namespace.
        (node name subStrings: $.) do: [ :each |
            start := start at: each asSymbol ifAbsent: [ ^ self checkDestination: start ] ].
        ^ self checkDestination: start
    ]

    checkDestination: anObject [
	<category: 'parsing'>

        anObject isClass ifTrue: [ ^ClassState with: anObject ].
        anObject isNamespace ifTrue: [ ^NamespaceState with: anObject ].
        ^ self defaultDestination
    ]

    selection [
	<category: 'accessing'>

        target isNil ifTrue: [^ self defaultDestination].

        ((target browserHasFocus not or: [ target sourceCodeWidgetHasFocus ])
            and: [target hasSelection])
                ifTrue: [^self computeStateFrom: target selectedText].

	^target state
    ]
]

