UndoCommand subclass: RenameNamespaceCommand [

    | namespace oldName newName treeStore |

    RenameNamespaceCommand class >> rename: aNamespace as: aSymbol onModel: aGtkNamespaceModel [
	<category: 'instance creation'>

	^ (self new)
	    rename: aNamespace as: aSymbol onModel: aGtkNamespaceModel;
	    precondition;
	    yourself
    ]

    rename: aNamespace as: aSymbol onModel: aGtkNamespaceModel [
	<category: 'initialize'>

	namespace := aNamespace.
	oldName := namespace name.
	newName := aSymbol.
	treeStore := aGtkNamespaceModel.
    ]

    description [
	<category: 'accessing'>

	^ 'Rename a namespace'
    ]

    precondition [
        <category: 'checking'>

        newName = #Smalltalk ifTrue: [ self error: 'Namespace name can''t be the same has a namespace name'  ].
        Smalltalk subspacesDo: [ :each | each name = newName ifTrue: [ self error: 'Namespace name can''t be the same has a namespace name'  ] ].
    ]

    undo [
	<category: 'events'>

	| iter |
	iter := treeStore findIterInANamespace: namespace.
	treeStore at: iter column: 0 value: oldName asString.
	namespace name: oldName
    ]

    redo [
	<category: 'events'>

	| iter |
	iter := treeStore findIterInANamespace: namespace.
	treeStore at: iter column: 0 value: newName asString.
	namespace name: newName
    ]
]

