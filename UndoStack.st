Object subclass: UndoStack [

    | stack |

    initialize [
	stack := OrderedCollection new.
    ]

    push: aCommand [
	aCommand redo.
	stack addFirst: aCommand
    ]

    pop [
	stack first undo.
	stack removeFirst
    ]
]

