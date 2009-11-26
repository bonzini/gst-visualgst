GtkListModel subclass: GtkCategoryModel [
 
    GtkCategoryModel class >> on: aClass [
	<category: 'instance creation'>
 
        ^ self new
	    classOrMeta: aClass;
	    yourself
    ]
 
    | classOrMeta |
 
    initialize [
        <category: 'initialize-release'>
 
	super initialize.
	self registerNotifier
    ]
 
    columns [
	<category: 'accessing'>
 
	^ {GTK.GValue gTypeString}
    ]
 
    item [
	<category: 'model builder'>
 
	| category |
	item := Set new.
	item add: '*'.
	self classOrMeta selectors do: [ :each |
	    category := (self classOrMeta compiledMethodAt: each) methodCategory.
	    item add: category ].
	^ item
    ]
 
    contentsBlock [
	<category: 'accessing'>
 
	^ [ :elem | {elem} ]
    ]
 
    registerNotifier [
	<category: 'initialize-release'>
 
	(SystemChangeNotifier uniqueInstance)
	    notify: self ofSystemChangesOfItem: #category change: #Added using: #'addEvent:';
	    notify: self ofSystemChangesOfItem: #category change: #Removed using: #'removeEvent:'
    ]
 
    classOrMeta [
	<category: 'accessing'>
    
	^ classOrMeta
    ]
 
    classOrMeta: aClass [
	<category: 'accessing'>
 
	classOrMeta := aClass.
	self refresh
    ]
 
    refresh [
	<category: 'events'>
   
	self clear.
	self classOrMeta ifNil: [ ^ self ].
	super refresh
    ]
 
    addEvent: anEvent [
        <category: 'event'>
 
        (anEvent itemClass == self classOrMeta) ifFalse: [ ^ self ].
        self append: {anEvent item}
    ]
 
    removeEvent: anEvent [
        <category: 'event'>
 
        (anEvent itemClass == self classOrMeta) ifFalse: [ ^ self ].
	self remove: anEvent item
    ]
]

