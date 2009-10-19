Object subclass: GtkCategorizedNamespaceModel [
    | model sorted |

    initialize [
	<category: 'initialize-release'>

	sorted := false.
	self registerNotifier
    ]

    registerNotifier [
	<category: 'initialize-release'>

	(SystemChangeNotifier uniqueInstance)
	    notify: self ofSystemChangesOfItem: #namespace change: #Added using: #'addEvent:';
	    notify: self ofSystemChangesOfItem: #namespace change: #Removed using: #'removeEvent:'
    ]

    isSorted [
	<category: 'testing'>

	^ sorted
    ]

    sorted: aBoolean [
	<category: 'accessing'>
	
	sorted := aBoolean
    ]

    gtkModel [
	<category: 'accessing'>

	^ model ifNil: [
	    model := GTK.GtkTreeStore new: 2 varargs: {GTK.GValue gTypeString. GTK.GValue gTypeString}.
	    self appendNamespace: Smalltalk to: nil.
	    model ]
    ]

    refresh [
	<category: 'model'>

	self gtkModel clear.
	self appendNamespace: Smalltalk to: nil
    ]

    appendNamespace: aNamespace to: parentGtkIter [
	<category: 'model builder'>

	
	| iter |
	iter := self gtkModel append: parentGtkIter item: {aNamespace displayString. 'N'}.

	self appendCategoriesOf: aNamespace into: iter.

	aNamespace subspacesDo: [ :each |
	    self appendNamespace: each to: iter ]
    ]

    appendCategoriesOf: aNamespace into: aGtkIter [
	<category: 'model builder'>

	| i ord |
	ord := OrderedCollection new.
	aNamespace do: [ :each |
	    | iter token |
	    (each isNil not and: [ each isClass and: [ each environment = aNamespace ] ])
		ifTrue: [
		    token := each category ifNil: [ #() ] ifNotNil: [ each category tokenize: '-' ].
		    iter := aGtkIter.
		    i := 1.
		    token do: [ :item |
			| set |
			set := i > ord size ifTrue: [ ord add: ((Set new) -> iter). (ord at: i) key ] ifFalse: [ iter := (ord at: i) value. (ord at: i) key ].
			(set includes: item) ifFalse: [
			    (i > 1 or: [ i = 1 and: [ item ~= aNamespace displayString ] ]) ifTrue: [
				iter := self gtkModel append: iter item: {item. 'C'}.
				set add: item ] ].
			i := i + 1 ] ] ]
    ]

    buildNamespaceArray: aNamespace [
	<category: 'item selection'>

	| result namespace |
        result := OrderedCollection new.
        namespace := aNamespace.
        [ namespace isNil ] whileFalse: [
            result addFirst: namespace displayString.
            namespace := namespace superspace ].

	^ result
    ]

    findIterInANamespace: aNamespace [
        <category: 'item selection'>

        | iter stack parent path |
        aNamespace = Smalltalk ifTrue: [ ^ self gtkModel getIterFirst ].

        stack := self buildNamespaceArray: aNamespace.
        iter := GTK.GtkTreeIter new.
	path := GTK.GtkTreePath newFirst.
        1 to: stack size do: [ :i | | each |
            each := stack at: i.
	    self gtkModel getIter: iter path: path.
            [ each = (self gtkModel getOop: iter column: 0) and: [ 'N' = (self gtkModel getOop: iter column: 1) ] ] whileFalse: [
		path next.
		(self gtkModel getIter: iter path: path) ifFalse: [ self error: 'Namespace ', each , ' not found' ] ].
	    path down ].
        ^ iter
    ]

    at: aGtkIter column: aSmallInteger value: anObject [
	<category: 'item accessing'>

	self gtkModel setOop: aGtkIter column: aSmallInteger value: anObject
    ]

    append: aParentIter column: aSmallInteger value: anObject [
	<category: 'item accessing'>

	| iter |
	iter := GTK.GtkTreeIter new.
	(self gtkModel)
            append: iter parent: aParentIter;
            setOop: iter column: aSmallInteger value: anObject
    ]

    remove: aNamespace [
	<category: 'item removing'>

	 | iter |
        iter := self findIterInANamespace: aNamespace.
        self gtkModel remove: iter
    ]

    addEvent: anEvent [
	<category: 'model event'>

	self
	    append: (self findIterInANamespace: anEvent item superspace)
	    column: 0
	    value: anEvent item displayString
    ]

    removeEvent: anEvent [
	<category: 'model event'>

	self remove: anEvent item
    ]
]

