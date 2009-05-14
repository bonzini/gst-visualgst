UndoCommand subclass: DeleteCategoryCommand [

    | category treeStore |

    DeleteCategoryCommand class >> delete: aSymbol onModel: aGtkCategoryModel [
	<category: 'instance creation'>

	^ (self new)
	    delete: aSymbol onModel: aGtkCategoryModel;
	    precondition;
	    yourself
    ]

    delete: aSymbol onModel: aGtkTreeStore [
	<category: 'initialize'>

	category := aSymbol.
	treeStore := aGtkTreeStore
    ]

    description [
	<category: 'accessing'>

	^ 'Rename a category'
    ]

    precondition [
        <category: 'checking'>

        category = '*' ifTrue: [ self error: 'Can''t delete a * category' ].
    ]

    undo [
	<category: 'events'>

	treeStore appendCategory: category
    ]

    redo [
	<category: 'events'>

	treeStore removeCategory: category
    ]
]

