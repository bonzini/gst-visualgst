GTK.GtkListStore extend [

    at: aGtkTreeIter [
	<category: 'accessing'>

	| values |
	aGtkTreeIter ifNil: [ ^ nil ].
	values := OrderedCollection new.
	0 to: self getNColumns - 1 do: [ :column |
	    values add: (self at: aGtkTreeIter column: column) ].
	^ values
    ]

    at: aGtkTreeIter column: anInteger [
	<category: 'accessing'>

	^ self getOop: aGtkTreeIter column: anInteger
    ]

    at: aGtkTreeIter column: anInteger put: anObject [
	<category: 'accessing'>

	self setOop: aGtkTreeIter column: anInteger value: anObject	
    ]

    at: aGtkTreeIter put: anArray [
	<category: 'accessing'>

	1 to: anArray size do: [ :i |
	    self at: aGtkTreeIter column: i - 1 put: (anArray at: i) ]
    ]

    at: aGtkTreeIter do: aBlock [
        <category: 'accessing'>

        (self at: aGtkTreeIter) do: aBlock
    ]

    appendItem: anArray [
	<category: 'accessing'>
   
	| iter |
	iter := self append.
	self at: iter put: anArray.
	^ iter
    ]

    prependItem: anArray [
        <category: 'accessing'>

        | iter |
        iter := self prepend.
        self at: iter put: anArray.
        ^ iter
    ]

    itersDo: aBlock [
	<category: 'accessing'>

	| iter |
	((iter := self getIterFirst) isNil or: [ (self iterIsValid: iter) not ] ) ifTrue: [ ^ nil ].
	aBlock value: iter.
	[ self iterNext: iter ] whileTrue: [ aBlock value: iter ]
    ]
   
    do: aBlock [
	<category: 'accessing'>

	self itersDo: [ :iter |
	    aBlock value: (self at: iter) value: iter ]
    ]

    lastIter [
	<category: 'accessing'>

	| lastIter iter path |
	iter := lastIter := GTK.GtkTreeIter new.
	path := GTK.GtkTreePath newFirst.
	[ self getIter: iter path: path ] whileTrue: [
	    lastIter := iter.
	    iter := GTK.GtkTreeIter new.
            path next ].
	^ lastIter
    ]
]

