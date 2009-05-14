UndoCommand subclass: RenameCategoryCommand [

    | category newCategory treeStore |

    RenameCategoryCommand class >> rename: aSymbol as: aNewName onModel: aGtkTreeStore [
	<category: 'instance creation'>

	^ (self new)
	    rename: aSymbol as: aNewName onModel: aGtkTreeStore;
	    precondition;
	    yourself
    ]

    rename: aSymbol as: aNewName onModel: aGtkTreeStore [
	<category: 'initialize'>

	category := aSymbol.
	newCategory := aNewName.
	treeStore := aGtkTreeStore
    ]

    description [
	<category: 'accessing'>

	^ 'Rename a category'
    ]

    precondition [
        <category: 'checking'>

	newCategory = '*' ifTrue: [ self error: 'Can''t create a * category' ].
        (treeStore hasCategory: newCategory asString) ifTrue: [ self error: 'Category is present' ]
    ]

    undo [
	<category: 'events'>

	treeStore
	    removeCategory: newCategory;
	    appendCategory: category
    ]

    redo [
	<category: 'events'>

	treeStore
	    removeCategory: category;
	    appendCategory: newCategory
    ]
]

