UndoCommand subclass: AddNamespaceUndoCommand [
    | parentNamespace newNamespace treeStore |

    AddNamespaceUndoCommand class >> add: aSymbol to: aNamespace onModel: aGtkNamespaceModel [
	<category: 'instance creation'>

	^ (self new)
	    add: aSymbol to: aNamespace onModel: aGtkNamespaceModel;
	    precondition;
	    yourself
    ]

    add: aSymbol to: aNamespace onModel: aGtkNamespaceModel [
	<category: 'initialize'>

	parentNamespace := aNamespace.
	newNamespace := aSymbol.
	treeStore := aGtkNamespaceModel.
    ]

    description [
	<category: 'accessing'>

	^ 'Add a namespace'
    ]

    precondition [
        <category: 'checking'>

        newNamespace = #Smalltalk ifTrue: [ self error: 'class name can''t be the same has a namespace name'  ].
        Smalltalk subspacesDo: [ :each | each name = newNamespace ifTrue: [ self error: 'class name can''t be the same has a namespace name'  ] ].
    ]

    undo [
	<category: 'events'>

	treeStore remove: (parentNamespace at: newNamespace).
	parentNamespace removeSubspace: newNamespace
    ]

    redo [
	<category: 'events'>

	treeStore
	    append: (treeStore findIterInANamespace: parentNamespace)
	    column: 0
	    value: newNamespace asString.
	parentNamespace addSubspace: newNamespace
    ]
]

