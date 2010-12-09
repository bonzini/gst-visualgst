Object subclass: BrowserState [
    | state |

    BrowserState class >> on: aBrowser with: aState [
	<category: 'instance creation'>

	^ self new
	    state: aState
    ]

    BrowserState class >> with: aState [
	<category: 'instance creation'>

	^ self new
	    state: aState
    ]

    hash [
	<category: 'testing'>

        ^self class hash bitXor: self state hash
    ]

    = aState [
	<category: 'testing'>

        ^self class = aState class and: [self state = aState state]
    ]

    state [
	<category: 'initialize-release'>

	^state
    ]

    state: aState [
	<category: 'initialize-release'>

	state := aState
    ]

    displayString [
        <category: 'printing'>

        ^ state displayString
    ]

    hasSelectedMethod [
        <category: 'testing'>

        ^ false
    ]

    hasSelectedCategory [
        <category: 'testing'>

        ^ false
    ]

    hasSelectedNamespace [
        <category: 'testing'>

        ^ false
    ]

    hasSelectedClass [
        <category: 'testing'>

        ^ false
    ]

    category [
        <category: 'accessing'>

        ^ nil
    ]

    method [
        <category: 'accessing'>

        ^ nil
    ]

    namespace [
        <category: 'accessing'>

        ^ nil
    ]

    classOrMeta [
        <category: 'accessing'>

        ^ nil
    ]

    classCategory [
        <category: 'accessing'>

        ^ self namespace categories
    ]

    namespaceState [
        <category: 'parent states'>

        | state |
        self hasSelectedNamespace ifFalse: [ self error: 'invalid browser state' ].
        state := NamespaceState with: self namespace.
        self hasSelectedClass ifTrue: [ state classCategory: self classCategory ].
        ^state
    ]

    categoryState [
        <category: 'parent states'>

        self hasSelectedCategory ifFalse: [ self error: 'invalid browser state' ].
        ^CategoryState with: self classOrMeta->self category
    ]

    classState [
        <category: 'parent states'>

        self hasSelectedClass ifFalse: [ self error: 'invalid browser state' ].
        ^ClassState with: self classOrMeta
    ]

    updateBrowser: aGtkClassBrowserWidget [
        <category: 'events'>
        "TODO"
    ]

    selectInBrowser: aGtkClassBrowserWidget [
        self updateBrowser: aGtkClassBrowserWidget.
    ]
]

