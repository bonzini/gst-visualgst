UndoCommand subclass: DeleteMethodCommand [

    | selector classOrMeta compiledMethod treeStore |

    DeleteMethodCommand class >> delete: aSymbol in: aClass onModel: aGtkMethodModel [
	<category: 'instance creation'>

	^ (self new)
	    delete: aSymbol in: aClass onModel: aGtkMethodModel;
	    precondition;
	    yourself
    ]

    delete: aSymbol in: aClass onModel: aGtkMethodModel [
	<category: 'initialize'>

	selector := aSymbol.
	classOrMeta := aClass.
	treeStore := aGtkMethodModel
    ]

    description [
	<category: 'accessing'>

	^ 'Add a method'
    ]

    precondition [
        <category: 'checking'>

    ]

    undo [
	<category: 'events'>

	classOrMeta methodDictionary at: selector put: compiledMethod.
	treeStore appendMethod: selector asString
    ]

    redo [
	<category: 'events'>

	compiledMethod := classOrMeta >> selector.
	classOrMeta methodDictionary remove: selector.
	treeStore removeMethod: selector asString
    ]
]

