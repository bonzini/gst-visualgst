Object subclass: GtkClassModel [
    GtkClassModel class [ | current | ]
    
    GtkClassModel class >> currentOn: aNamespace [
	<category: 'accessing'>

	current ifNil: [ current := Dictionary new ].
	^ current at: aNamespace ifAbsentPut: [ self on: aNamespace]
    ]

    GtkClassModel class >> on: aNamespace [
	<category: 'instance creation'>

	^ (self new)
	    initialize;
	    namespace: aNamespace;
	    yourself
    ]

    | model namespace sorted |

    initialize [
	<category: 'initialize-release'>

	sorted := false
    ]

    isSorted [
        <category: 'testing'>

        ^ sorted
    ]

    sorted: aBoolean [
        <category: 'accessing'>

        sorted := aBoolean
    ]

    namespace [
	<category: 'accessing'>
    
	^ namespace
    ]

    namespace: aNamespace [
	<category: 'accessing'>

	namespace := aNamespace.
	self refreshModel
    ]

    model [
	<category: 'accessing'>

	^ model ifNil: [
	    model := GTK.GtkTreeStore new: 1 varargs: {GTK.GValue gTypeString} ]
    ]

    refreshModel [
	<category: 'events'>
	
	self model clear.

	Class subclassesDo: [ :each |
		self appendClass: each to: nil].
    ]

    appendClass: aClass to: parentGtkIter [
	<category: 'model builder'>
    
	| iter string |
	aClass environment = self namespace ifTrue: [
	    string := ((aClass displayString) substrings: $.) last.
	    iter := GTK.GtkTreeIter new.
	    self model append: iter parent: parentGtkIter.
	    self model setOop: iter column: 0 value: string.
	].

	aClass subclassesDo: [ :each |
	    self appendClass: each to: iter ]
    ]

    buildClassArray: aClass [
        <category: 'item selection'>

        | result class |
        result := OrderedCollection new.
        class := aClass.
        [ class isNil not and: [ class environment = self namespace ] ] whileTrue: [
            result add: class name asString.
            class := class superclass ].

        ^ result
    ]

    hasClass: aClass [
	<category: 'item testing'>

	| iter stack parent path pathString number |
        stack := self buildClassArray: aClass.
	stack isEmpty ifTrue: [ ^ false ].
        iter := GTK.GtkTreeIter new.
        path := GTK.GtkTreePath newFirst.
        1 to: stack size do: [ :i | | each |
            each := stack at: (stack size + 1 - i).
            self model getIter: iter path: path.
            [each, ' class' = (self model getOop: iter column: 0)] whileFalse: [
                path next.
                (self model getIter: iter path: path)  ifFalse: [ ^ false ] ].
            path down ].
        ^ true
    ]

    findIterInAClass: aClass [
        <category: 'item selection'>

        | iter stack parent path pathString number |
        stack := self buildClassArray: aClass.
        iter := GTK.GtkTreeIter new.
	path := GTK.GtkTreePath newFirst.
        1 to: stack size do: [ :i | | each |
            each := stack at: (stack size + 1 - i).
	    self model getIter: iter path: path.
            [each, ' class' = (self model getOop: iter column: 0)] whileFalse: [
		path next.
		(self model getIter: iter path: path)  ifFalse: [ self error: aClass name, ' is not found' ] ].
	    path down ].
        ^ iter
    ]

    at: aGtkIter column: aSmallInteger value: anObject [
        <category: 'item accessing'>

        self model setOop: aGtkIter column: aSmallInteger value: anObject
    ]

    append: aParentIter column: aSmallInteger value: anObject [
        <category: 'item accessing'>

        | iter |
        iter := GTK.GtkTreeIter new.
        (self model)
            append: iter parent: aParentIter;
            setOop: iter column: aSmallInteger value: anObject
    ]

    remove: aClass [
	<category: 'item removing'>

	| iter |
	iter := self findIterInAClass: aClass.
	self model remove: iter
    ]
]

