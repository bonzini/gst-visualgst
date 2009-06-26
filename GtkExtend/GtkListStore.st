GTK.GtkListStore extend [

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

