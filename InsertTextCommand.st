UndoCommand subclass: InsertTextCommand [
    | string offset |

    InsertTextCommand class >> insert: aString at: anOffset [
	<category: 'instance creation'>

	^ (self new)
	    insert: aString at: anOffset;
	    yourself
    ]

    insert: aString at: anOffset [
	<category: 'initialize'>

	string := aString.
	offset := anOffset
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

    ]

    redo [
	<category: 'events'>

    ]
]

