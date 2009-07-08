UndoCommand subclass: DeleteCategoryCommand [

    | category class methods treeStore |

    DeleteCategoryCommand class >> delete: aString in: aClass onModel: aGtkCategoryModel [
	<category: 'instance creation'>

	^ (self new)
	    delete: aString in: aClass onModel: aGtkCategoryModel;
	    precondition;
	    yourself
    ]

    delete: aString in: aClass onModel: aGtkTreeStore [
	<category: 'initialize'>

	category := aString.
	class := aClass.
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

        methods do: [ :each |
            class methodDictionary at: each selector put: each ].
	methods := nil.
	treeStore appendCategory: category.
	(GtkMethodModel
            currentOn: class withCategory: '*') refreshModel.
    ]

    redo [
	<category: 'events'>

	methods := OrderedCollection new.
	class methodDictionary do: [ :each |
	    each methodCategory = category 
		ifTrue: [ methods add: each ] ].
	methods do: [ :each |
	    class methodDictionary removeKey: each selector ifAbsent: [ ] ].
	treeStore removeCategory: category.
	(GtkMethodModel 
	    currentOn: class withCategory: '*') refreshModel.
    ]
]

