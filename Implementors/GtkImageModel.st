Object subclass: GtkImageModel [
    GtkImageModel class [ | current | ]

    GtkImageModel class >> current [
	<category: 'accessing'>

	^ current ifNil: [ current := (self new)
					initialize;
					yourself ]
    ]

    GtkImageModel class >> currentModel [
        <category: 'accessing'>

        ^ self current model
    ]

    | finderDic model |

    initialize [
	<category: 'initialize-release'>

	finderDic := Dictionary new.
	self
	    model;
            buildNamespaceModel;
            buildClassModel;
            buildMethodModel
    ]

    model [
	<category: 'accessing'>

	^ model ifNil: [
	    model := GTK.GtkListStore new: 1 varargs: {GTK.GValue gTypeString} ]
    ]

    buildNamespaceModel [
        <category: 'model builder'>

        self appendNamespace: Smalltalk
    ]

    appendNamespace: aNamespace [
        <category: 'model builder'>

        finderDic at: aNamespace displayString ifAbsentPut: [ self appendToModel: aNamespace displayString. OrderedCollection new ].
        (finderDic at: aNamespace displayString) add: (NamespaceFinder on: aNamespace).

        aNamespace subspacesDo: [ :each | self appendNamespace: each ]
    ]

    buildClassModel [
        <category: 'model builder'>

        | string |
        Class allSubclassesDo: [ :each |
            string := ((each displayString) substrings: $.) last.
            finderDic at: string ifAbsentPut: [ self appendToModel: string. OrderedCollection new ].
            (finderDic at: string) add: (ClassFinder on: each) ]
    ]

    buildMethodModel [
        <category: 'model builder'>

        [ CompiledMethod allInstancesDo: [ :each | | selector |
            selector := each selector asString.
            finderDic at: selector ifAbsentPut: [ self appendToModel: selector. OrderedCollection new ].
            (finderDic at: selector) add: (MethodFinder on: each methodClass with: each selector) ] ] forkAt: Processor highestPriority
    ]

    appendToModel: aString [
        <category: 'model builder'>

        self model insertWithValues: nil position: 0 varargs: {0. aString. -1}
    ]

    selectedItem: aGtkIter [
	<category: 'item selection'>

	| string |
	string := (self model getOop: aGtkIter column: 0).
        ^ finderDic at: string ifAbsent: [ self error: 'Element not found' ].
    ]
]
