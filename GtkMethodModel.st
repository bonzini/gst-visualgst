Object subclass: GtkMethodModel [

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

        sorted := false.
	self registerNotifier
    ]

    registerNotifier [
	<category: 'initialize-release'>

	(VisualGST uniqueInstance systemChangeNotifier)
	    notify: self ofSystemChangesOfItem: #method change: #Added using: #'addEvent:';
	    notify: self ofSystemChangesOfItem: #method change: #Removed using: #'removeEvent:'
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

    gtkModel: aModel [
	<category: 'accessing'>

	model := aModel
    ]

    refreshModel [
	<category: 'events'>
    
	self classOrMeta ifNil: [ ^ self ].

	self gtkModel clear.

	self classOrMeta selectors do: [ :each |
	    (self category = '*' or: [ ((self classOrMeta compiledMethodAt: each) methodCategory = self category) ])
		ifTrue: [ self appendMethod: each asString ] ]
    ]

    appendMethod: aString [
	<category: 'model builder'>
    
        (self findIterInAMethod: aString) isNil ifFalse: [^self].
	self gtkModel appendItem: {aString}
    ]

    removeMethod: aString [
        <category: 'model builder'>

        | iter |
        iter := self findIterInAMethod: aString.
	iter isNil ifTrue: [^self].
        self gtkModel remove: iter
    ]

    includesCategory: aSymbol [
	<category: 'testing'>

	self category = '*' ifTrue: [ ^ true ].
	(self category = 'still unclassified' and: [ aSymbol isNil ]) ifTrue: [ ^ true ].
	^ self category = aSymbol
    ]

    addEvent: anEvent [
	<category: 'event'>

	(anEvent item methodClass == self classOrMeta and: [ self includesCategory: anEvent item methodCategory ] ) ifFalse: [ ^ self ].
	self appendMethod: anEvent item selector asString
    ]

    removeEvent: anEvent [
	<category: 'event'>

	(anEvent item methodClass == self classOrMeta and: [ self includesCategory: anEvent item methodCategory ]) ifFalse: [ ^ self ].
        self removeMethod: anEvent item selector asString
    ]
]

