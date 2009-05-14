Object subclass: GtkMethodModel [
    GtkMethodModel class [ | current | ]

    GtkMethodModel class >> currentOn: aClass withCategory: aCategory [
	<category: 'accessing'>

	current ifNil: [ current := Dictionary new ].
	^ (current at: aClass ifAbsentPut: [ Dictionary new ])
	    at: aCategory ifAbsentPut: [ self on: aClass withCategory: aCategory ]
    ]

    GtkMethodModel class >> on: aClass withCategory: aCategory [
	<category: 'instance creation'>

        ^ (self new)
	    initialize;
	   classOrMeta: aClass withCategory: aCategory;
	    yourself
    ]

    | model classOrMeta category sorted |

    initialize [
        <category: 'initialize-release'>

        sorted := false
    ]

    isSorted [
        <category: 'testing'>

        ^ sorted
    ]

    sorted: aBoolean [
        <category: 'accessing'>

        sorted := aBoolean
    ]

    classOrMeta [
	<category: 'accessing'>
    
	^ classOrMeta
    ]

    category [
	<category: 'accessing'>

	^ category
    ]

    category: aString [
	<category: 'accessing'>

	category := aString.
	self refreshModel
    ]

    classOrMeta: aClass withCategory: aString [
	<category: 'accessing'>

	classOrMeta := aClass.
	self category: aString
    ]

    model [
	<category: 'accessing'>

	^ model ifNil: [
	    model := GTK.GtkListStore new: 1 varargs: {GTK.GValue gTypeString} ]
    ]

    emptyModel [
	<category: 'accessing'>

	^ GTK.GtkListStore new: 1 varargs: {GTK.GValue gTypeString}
    ]

    refreshModel [
	<category: 'events'>
    
	self classOrMeta ifNil: [ ^ model := self emptyModel ].

	self classOrMeta selectors do: [ :each |
	    (((self classOrMeta compiledMethodAt: each) methodCategory = self category) or: [ self category = '*'])
		ifTrue: [ self appendMethod: each asString ] ]
    ]

    buildCategory [
	<category: 'model builder'>

	| category set |
	set := Set new.
	self classOrMeta selectors do: [ :each |
	    category := (self classOrMeta compiledMethodAt: each) methodCategory.
	    set add: category ].
	^ set
    ]

    findIterInAMethod: aString [
        <category: 'item selection'>

        | iter stack parent path pathString number |
        iter := GTK.GtkTreeIter new.
        path := GTK.GtkTreePath newFirst.
        [self model getIter: iter path: path] whileTrue: [
            self model getIter: iter path: path.
            (aString = (self model getOop: iter column: 0))
                ifTrue: [ ^ iter  ].
            path next ].
        self error: 'Method not found'
    ]

    appendMethod: aString [
	<category: 'model builder'>
    
	| iter |
        iter := GTK.GtkTreeIter new.
        self model append: iter.
        self model setOop: iter column: 0 value: aString
    ]

    removeMethod: aString [
        <category: 'model builder'>

        | iter |
        iter := self findInterInAMethod: aString.
        self model remove: iter
    ]
]

