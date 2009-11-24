GtkTreeModel subclass: GtkCategorizedClassModel [

    GtkCategorizedClassModel class >> on: aNamespace category: aString [
	<category: 'instance creation'>

	^ (self new)
	    initialize;
	    namespace: aNamespace category: aString;
	    yourself
    ]

    | category namespace |

    initialize [
	<category: 'initialize-release'>

	sorted := false.
	self registerNotifier
    ]

    registerNotifier [
	<category: 'initialize-release'>

	(SystemChangeNotifier uniqueInstance)
	    notify: self ofSystemChangesOfItem: #class change: #Added using: #'addEvent:';
	    notify: self ofSystemChangesOfItem: #class change: #Removed using: #'removeEvent:';
	    notify: self ofSystemChangesOfItem: #class change: #Recategorized using: #'recategorizedEvent:'
    ]

    namespace [
	<category: 'accessing'>
    
	^ namespace
    ]

    namespace: aNamespace [
	<category: 'accessing'>

	namespace := aNamespace.
	self refresh
    ]

    category: aString [
	<category: 'accessing'>

	category := aString
    ]

    category [
	<category: 'accessing'>

	^ category
    ]

    namespace: aNamespace category: aString [
	<category: 'initialize'>

	self
	    category: aString;
	    namespace: aNamespace
    ]

    columns [
        <category: 'accessing'>

        ^ {GTK.GValue gTypeString}
    ]

    item [
	<category: 'accessing'>

	^ Class
    ]

    isInEnvironment: aClass [
    <category: 'testing'>

        aClass environment == self namespace ifFalse: [ ^ false ].
        ^ (self category = '' or: [ self category = aClass category ]) or: [ (self namespace displayString, '-', self category) = aClass category ]
    ]

    childrenBlock [
	<category: 'accessing'>

	^ [ :elem |
	    self append: elem to: OrderedCollection new ]
    ]

    append: aClass to: anArray [
	<category: 'accessing'>

	aClass subclassesDo: [ :each |
	    (self isInEnvironment: each) ifTrue: [ anArray add: ({each asClass name asString, ' '} -> (self append: each to: OrderedCollection new)) ] ].
	^ anArray
    ]

    "contentsBlock [
    <category: 'accessing'>

	^ [ :elem | {elem asClass name asString, ' '} ]
    ]"

    findIter: aClass ifAbsent: aBlock [
        <category: 'item selection'>

	^ super findIter: (self contentsBlock value: aClass) first ifAbsent: aBlock
    ]

    remove: aClass [
	<category: 'item removing'>

	| iter |
	iter := self findIter: aClass ifAbsent: [ nil ].
	iter isNil ifFalse: [ self gtkModel remove: iter ]
    ]

    addEvent: anEvent [
	<category: 'model event'>

	| iter |
	(self isInEnvironment: anEvent item) ifFalse: [ ^ self ].
	iter := self findIter: anEvent item superclass ifAbsent: [ nil ].
	self append: (self contentsBlock value: anEvent item) parent: iter
    ]

    removeEvent: anEvent [
        <category: 'model event'>

	(self isInEnvironment: anEvent item) ifFalse: [ ^ self ].
	(self hasItem: anEvent item) ifFalse: [ ^ self ].
        self remove: anEvent item
    ]

    recategorizedEvent: anEvent [
        <category: 'model event'>

       | iter |
	anEvent item environment == self namespace ifFalse: [ ^ self ].
	anEvent oldCategory = anEvent item category ifTrue: [ ^ self ].
	(anEvent oldCategory = self category or: [ self category isEmpty ]) ifTrue: [ ^ self remove: anEvent item ].
	(anEvent item category = self category or: [ self category isEmpty ]) ifTrue: [ 
	    iter := self findIter: anEvent item superclass ifAbsent: [ nil ].
	    self append: (self contentsBlock value: anEvent) parent: iter ].
    ]
]

