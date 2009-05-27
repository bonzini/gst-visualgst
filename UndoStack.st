Object subclass: UndoStack [

    | undoStack redoStack |

    initialize [
	<category: 'initialization'>

	undoStack := OrderedCollection new.
	redoStack := OrderedCollection new.
    ]

    push: aCommand [
	<category: 'stack'>

	aCommand redo.
	undoStack addFirst: aCommand
    ]

    pop [
	<category: 'stack'>

	undoStack first undo.
	undoStack removeFirst
    ]

    undo [
	<category: 'undo-redo'>

	| cmd |
	cmd := undoStack first
		    undo;
		    yourself.
	redoStack addFirst: undoStack removeFirst.
    ]

    redo [
        <category: 'undo-redo'>

        | cmd |
        cmd := redoStack first
		    redo;
		    yourself.
        undoStack addFirst: redoStack removeFirst.
    ]
]

