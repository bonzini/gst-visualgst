GTK.GtkListStore extend [

    at: aGtkTreeIter column: anInteger put: anObject [
	<category: 'accessing'>

	self setOop: aGtkTreeIter column: anInteger value: anObject	
    ]

    at: aGtkTreeIter put: anArray [
	<category: 'accessing'>

	1 to: anArray size do: [ :i |
	    self at: aGtkTreeIter column: i - 1 put: (anArray at: i) ]
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

