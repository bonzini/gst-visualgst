UndoCommand subclass: DeleteClassCommand [

    |  class treeStore |

    DeleteClassCommand class >> delete: aClass onModel: aGtkClassModel [
	<category: 'instance creation'>

	^ (self new)
	    delete: aClass onModel: aGtkClassModel;
	    yourself
    ]

    delete: aClass onModel: aGtkClassModel [
	<category: 'initialize'>

	class := aClass.
	treeStore := aGtkClassModel
    ]

    description [
	<category: 'accessing'>

	^ 'Delete a namespace'
    ]

    undo [
	<category: 'events'>

	| iter |
	treeStore hasClass: class superclass 
	    ifTrue: [ iter := treeStore findIterInAClass: class superclass ].
	treeStore append: iter column: 0 value: class asString.
	class environment add: class
    ]

    redo [
	<category: 'events'>

	treeStore remove: class.	
	class environment removeKey: class name
    ]
]

