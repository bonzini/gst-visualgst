Object subclass: UndoCommand [
    | description preconditionError |

    description [
	<category: 'accessing'>

	^ self subclassResponsibility 
    ]

    precondition [
	<category: 'checking'>

	^ true
    ]

    preconditionFailed: aString [
	<category: 'checking'>

	preconditionError := aString.
	^ false
    ]

    error [
	<category: 'checking'>

	^ preconditionError
    ]

    undo [
	<category: 'events'>

	self subclassResponsibility
    ]

    redo [
	<category: 'events'>

	self subclassResponsibility 
    ]

    displayError [
        <Category: 'error'>

        GtkLauncher displayError: self description message: self error
    ]
]

