GtkListModel subclass: GtkMethodModel [
 
    GtkMethodModel class >> on: aClass withCategory: aCategory [
	<category: 'instance creation'>
 
        ^ self new
	    classOrMeta: aClass withCategory: aCategory;
	    yourself
    ]
 
    | classOrMeta category |
 
    initialize [
        <category: 'initialize-release'>

	super initialize.
	self registerNotifier.
    ]
 
    columns [
        <category: 'accessing'>
 
        ^ {GTK.GValue gTypeString}
    ]
 
    item [
        <category: 'accessing'>
 
	^ self classOrMeta
    ]
 
    contentsBlock [
        <category: 'accessing'>
 
        ^ [ :elem | 
		item := OrderedCollection new.
		self classOrMeta selectors do: [ :each |
		    (self includesCategory: (self classOrMeta compiledMethodAt: each) methodCategory)
			ifTrue: [ item add: {each} ] ].
	    item ]
    ]
 
    registerNotifier [
	<category: 'initialize-release'>
 
	(SystemChangeNotifier uniqueInstance)
	    notify: self ofSystemChangesOfItem: #method change: #Added using: #'addEvent:';
	    notify: self ofSystemChangesOfItem: #method change: #Removed using: #'removeEvent:'
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
	self refresh
    ]
 
    classOrMeta: aClass withCategory: aString [
	<category: 'accessing'>
 
	classOrMeta := aClass.
	self category: aString
    ]
 
    refresh [
	<category: 'events'>
   
	self clear.
	self classOrMeta ifNil: [ ^ self ].
	super refresh
    ]

    "
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

	self gtkModel do: [ :elem :iter |
	    elem first = aString ifTrue: [ ^ iter ] ].
        ^nil
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

    "includesCategory: aSymbol [
	<category: 'testing'>
 
	self category = '*' ifTrue: [ ^ true ].
	(self category = 'still unclassified' and: [ aSymbol isNil ]) ifTrue: [ ^ true ].
	^ self category = aSymbol
    ]
 
    addEvent: anEvent [
	<category: 'event'>
 
	(anEvent item methodClass == self classOrMeta and: [ self includesCategory: anEvent item methodCategory ] ) ifFalse: [ ^ self ].
	self append: {anEvent item selector asString}
    ]
 
    removeEvent: anEvent [
	<category: 'event'>
 
	(anEvent item methodClass == self classOrMeta and: [ self includesCategory: anEvent item methodCategory ]) ifFalse: [ ^ self ].
        self remove: anEvent item selector asString
    ]"
]

