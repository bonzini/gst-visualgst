UndoCommand subclass: InsertTextCommand [
    | first string offset buffer |

    InsertTextCommand class >> insert: aString at: anOffset on: aGtkTextBuffer [
	<category: 'instance creation'>

	^ (self new)
	    insert: aString at: anOffset on: aGtkTextBuffer;
	    yourself
    ]

    insert: aString at: anOffset on: aGtkTextBuffer [
	<category: 'initialize'>

	first := true.
	string := aString.
	offset := anOffset.
	buffer := aGtkTextBuffer
    ]

    isInsertCommand [
	<category: 'testing'>

	^ true
    ]

    isDeleteCommand [
	<category: 'testing'>

	^ false
    ]

    offset [
	<category: 'accessing'>

	^ offset
    ]

    string [
	<category: 'accessing'>

	^ string
    ]

    string: aString [
	<category: 'accessing'>

	string := aString
    ]

    size [
	<category: 'accessing'>

	^ string size
    ]

    description [
	<category: 'accessing'>

	^ 'Insert a string'
    ]

    undo [
	<category: 'events'>

	buffer deleteInteractive: (buffer getIterAtOffset: self offset) endIter: (buffer getIterAtOffset: self offset + self string size) defaultEditable: true
    ]

    redo [
	<category: 'events'>

	| iter |
	first ifTrue: [ first:= false. 
	    ^ self ].
	buffer insertInteractive: (buffer getIterAtOffset: self offset) text: self string len: self string size defaultEditable: true
    ]
]

