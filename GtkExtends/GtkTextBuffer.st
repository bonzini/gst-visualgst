GTK.GtkTextBuffer extend [

    insertAtEnd: aString [
	<category: 'accessing'>

	self insert: self getEndIter text: aString
    ]
]

