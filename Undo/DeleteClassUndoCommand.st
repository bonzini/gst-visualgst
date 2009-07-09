UndoCommand subclass: DeleteClassUndoCommand [

    |  class treeStore |

    DeleteClassUndoCommand class >> delete: aClass onModel: aGtkClassModel [
	<category: 'instance creation'>

	^ (self new)
	    delete: aClass onModel: aGtkClassModel;
	    precondition;
	    yourself
    ]

    delete: aClass onModel: aGtkClassModel [
	<category: 'initialize'>

	class := aClass.
	treeStore := aGtkClassModel
    ]

    description [
	<category: 'accessing'>

	^ 'Delete a class'
    ]

    precondition [
	<category: 'checking'>

        class subclasses isEmpty ifFalse: [ self error: 'class has subclasses' ].
    ]

    undo [
	<category: 'events'>

	| iter |
	(treeStore hasClass: class superclass) 
	    ifTrue: [ iter := treeStore findIterInAClass: class superclass ].
	treeStore append: iter column: 0 value: class name asString, ' class'.
	class superclass addSubclass: class.
	class environment at: class name put: class
    ]

    redo [
	<category: 'events'>

	treeStore remove: class.
	class superclass ifNotNil: [ class superclass removeSubclass: class ].
	class environment removeKey: class name
    ]
]

