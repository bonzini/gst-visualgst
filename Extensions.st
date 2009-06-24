Object extend [

    gtkInspect [
	"Open a GtkInspector on self"
	<category: 'debugging'>

	VisualGST.GtkInspector openOn: self
    ]

    inspectorView [
	<category: 'gtklauncher'>

	^ VisualGST.GtkObjectInspectorView
    ]

    hasLiterals [
	<category: 'testing'>

	^ false
    ]
]

SequenceableCollection extend [
    inspectorView [
        <category: 'gtklauncher'>

        ^ VisualGST.GtkSequenceableCollectionInspectorView
    ]
]

Character extend [
    inspectorView [
        <category: 'gtklauncher'>

        ^ VisualGST.GtkCharacterInspectorView
    ]
]

Integer extend [
    inspectorView [
        <category: 'gtklauncher'>

        ^ VisualGST.GtkIntegerInspectorView
    ]
]

Float extend [
    inspectorView [
        <category: 'gtklauncher'>

        ^ VisualGST.GtkFloatInspectorView
    ]
]

Symbol extend [
    hasLiterals [
	<category: 'testing'>

	^ true
    ]

    symbolFromliterals [
	<category: 'accessing'>

	^ {self}
    ]
]

Array extend [
    hasLiterals [
	<category: 'testing'>

	self do: [ :each |
	    each hasLiterals ifTrue: [ ^ true ] ].
	^ false
    ]

    symbolFromliterals [
        <category: 'accessing'>

	| result |
	result := OrderedCollection new.
	self do: [ :each |
	    each hasLiterals ifTrue: [ result add: each symbolFromliterals first ] ].
        ^ result
    ]
]

Class extend [

    subclass: classNameString environment: aNamespace [
    "Define a subclass of the receiver with the given name.  If the class
     is already defined, don't modify its instance or class variables
     but still, if necessary, recompile everything needed."

    <category: 'instance creation'>
    | meta |
    KernelInitialized ifFalse: [^Smalltalk at: classNameString].
    meta := self metaclassFor: classNameString.
    ^meta 
     name: classNameString
        environment: aNamespace
        subclassOf: self
    ]
]

CompiledCode extend [

    hasLiterals [
	<category: 'testing'>

	^ self literals isEmpty not
    ]

    isSendingWithSpecialSelector: aByteCode [
	<category: 'testing'>

	^ aByteCode <= 31
    ]

    specialSelectorSended: aByteCode and: anOperand [
	<category: 'accessing'>

	(self isSendingWithSpecialSelector: aByteCode) ifFalse: [ ^ self error: 'bad byte code' ].
	aByteCode <= 26 ifTrue: [ ^ self class specialSelectors at: aByteCode + 1 ].
        (aByteCode = 30 or: [ aByteCode = 31 ]) ifTrue: [ ^ self class specialSelectors at: anOperand + 1 ].
    ]

    extractSpecialSelectors [
	<category: 'accessing'>
	
	| result |
	result := Set new.
        self allByteCodeIndicesDo: [ :i :bytecode :operand |
	    (self isSendingWithSpecialSelector: bytecode) ifTrue: [
		result add: (self specialSelectorSended: bytecode and: operand) ] ].
	^ result
    ]

    literalsAndSpecialSelectors [
	"Answer whether the receiver refers to the given object"

        <category: 'accessing'>
        | result |
	result := Set new.
	self literalsDo: [ :each |
	    each hasLiterals ifTrue: [ result addAll: each symbolFromliterals ] ].

        ^ result + self extractSpecialSelectors
    ]

    literalsAndSpecialSelectorsDo: aOneArgBlock [
	<category: 'accessing'>

	self literalsAndSpecialSelectors do: aOneArgBlock
    ]
]

CompiledBlock extend [
    symbolFromliterals [
	^ self extractSpecialSelectors
    ]
]

