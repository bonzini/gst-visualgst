UndoCommand subclass: AddMethodCommand [

    | method category classOrMeta compiledMethod treeStore |

    AddMethodCommand class >> add: aString classified: aCategory in: aClass onModel: aGtkMethodModel [
	<category: 'instance creation'>

	^ (self new)
	    add: aString classified: aCategory in: aClass onModel: aGtkMethodModel;
	    precondition;
	    yourself
    ]

    add: aString classified: aCategory in: aClass onModel: aGtkMethodModel [
	<category: 'initialize'>

	method := aString.
	category := aCategory.
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

	classOrMeta methodDictionary remove: compiledMethod selector.
	treeStore removeMethod: compiledMethod selector asString
    ]

    redo [
	<category: 'events'>

	compiledMethod := classOrMeta
			    compile: method
			    classified: category
			    ifError: [ :fname :lineNo :errorString |
				^ self error: 'Compile error ', errorString ].

	treeStore appendMethod: compiledMethod selector asString
    ]
]

