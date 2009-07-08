UndoCommand subclass: AddMethodCommand [

    | selector method category classOrMeta oldCompiledMethod treeStore |

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

	| parser |
        parser := STInST.RBBracketedMethodParser new
                    errorBlock: [ :string :pos | ^ self error: string ];
                    initializeParserWith: method type: #'on:errorBlock:';
                    yourself.
	selector := parser parseMethod selector.
    ]

    undo [
	<category: 'events'>

	classOrMeta methodDictionary removeKey: selector.
	oldCompiledMethod 
	    ifNotNil: [ classOrMeta methodDictionary at: selector put: oldCompiledMethod ]
	    ifNil: [ treeStore removeMethod: selector asString ]
    ]

    redo [
	<category: 'events'>

	oldCompiledMethod := classOrMeta methodDictionary ifNotNil: [ classOrMeta methodDictionary at: selector ifAbsent: [ nil ] ].
	classOrMeta
	    compile: method
	    classified: category
	    ifError: [ :fname :lineNo :errorString |
			^ self error: 'Compile error ', errorString ].
	oldCompiledMethod ifNil: [ treeStore appendMethod: selector asString ]
    ]
]

