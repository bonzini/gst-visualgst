Object subclass: UndoCommand [
    | description |

    description [
	<category: 'accessing'>

	^ self subclassResponsibility 
    ]

    precondition [
	<category: 'checking'>

	^ true
    ]

    undo [
	<category: 'events'>

	self subclassResponsibility
    ]

    redo [
	<category: 'events'>

	self subclassResponsibility 
    ]
]

