GTK.GtkTreeStore extend [

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

    itersDo: aBlock iter: aGtkTreeIter [
	<category: 'accessing'>

	| childIter |
	childIter := GTK.GtkTreeIter new.
	aBlock value: aGtkTreeIter.
	(self iterChildren: childIter parent: aGtkTreeIter) ifTrue: [ self itersDo: aBlock iter: childIter ].
	[ self iterNext: aGtkTreeIter ] whileTrue: [
	    aBlock value: aGtkTreeIter.
            (self iterChildren: childIter parent: aGtkTreeIter) ifTrue: [ self itersDo: aBlock iter: childIter ] ]
    ]

    itersDo: aBlock [
	<category: 'accessing'>

	| iter child |
	((iter := self getIterFirst) isNil or: [ (self iterIsValid: iter) not ] ) ifTrue: [ ^ nil ].
	self itersDo: aBlock iter: iter
    ]

    do: aBlock [
        <category: 'accessing'>

        self itersDo: [ :iter |
            aBlock value: (self at: iter) value: iter ]
    ]

    append: aGtkTreeIter item: anArray [
	<category: 'accessing'>

        | iter |
        iter := GTK.GtkTreeIter new.
        self 
	    append: iter parent: aGtkTreeIter;
	    at: iter put: anArray.
	^ iter
    ]
]

