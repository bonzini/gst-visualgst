UndoCommand subclass: DeleteNamespaceUndoCommand [

    |  namespace treeStore |

    DeleteNamespaceUndoCommand class >> delete: aNamespace onModel: aGtkNamespaceModel [
	<category: 'instance creation'>

	^ (self new)
	    delete: aNamespace onModel: aGtkNamespaceModel;
	    yourself
    ]

    delete: aNamespace onModel: aGtkNamespaceModel [
	<category: 'initialize'>

	namespace := aNamespace.
	treeStore := aGtkNamespaceModel
    ]

    description [
	<category: 'accessing'>

	^ 'Delete a namespace'
    ]

    undo [
	<category: 'events'>

	treeStore
	    append: (treeStore findIterInANamespace: namespace superspace)
	    column: 0
	    value: namespace name.
	namespace superspace at: namespace name put: namespace.
	namespace superspace subspaces add: namespace
    ]

    redo [
	<category: 'events'>

	treeStore remove: namespace.
	namespace superspace removeSubspace: namespace name
    ]
]

