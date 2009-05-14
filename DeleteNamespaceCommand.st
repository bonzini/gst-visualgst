UndoCommand subclass: DeleteNamespaceCommand [

    |  namespace treeStore |

    DeleteNamespaceCommand class >> delete: aNamespace onModel: aGtkNamespaceModel [
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
	    value: namespace asString.
	namespace surperspace addSubspace: namespace
    ]

    redo [
	<category: 'events'>

	treeStore remove: namespace.
	namespace superspace removeSubspace: namespace name
    ]
]

