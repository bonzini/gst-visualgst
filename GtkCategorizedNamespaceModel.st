GtkTreeModel subclass: GtkCategorizedNamespaceModel [
    | category categoryIcon namespace namespaceIcon |

    GtkCategorizedNamespaceModel class >> displayedNamespaceColumn [
        <category: 'accessing'>

        ^ 1 
    ]

    GtkCategorizedNamespaceModel class >> namespaceColumn [
        <category: 'accessing'>

        ^ 2
    ]

    GtkCategorizedNamespaceModel class >> categoryColumn [
        <category: 'accessing'>

        ^ 3
    ]

    namespace: aNamespace [
        <category: 'accessing'>

	namespace := aNamespace.
	self refresh
    ]

    namespace [
        <category: 'accessing'>

        ^ namespace ifNil: [ namespace := Smalltalk ]
    ]

    category: aString [
        <category: 'accessing'>

        category := aString
    ]

    category [
        <category: 'accessing'>

	^ category ifNil: [ category := '' ]
    ]

    namespace: aNamespace category: aString [
        <category: 'accessing'>

        self
	    category: aString; 
	    namespace: aNamespace
    ]    

    columns [
        <category: 'accessing'>

	^ {GTK.GdkPixbuf getType. GTK.GValue gTypeString. GTK.GLib oopType. GTK.GValue gTypeString}
    ]

    item [
        <category: 'accessing'>

        ^ self namespace
    ]

    isSorted [

	^ true
    ]

    initialize [
	<category: 'initialize-release'>

	super initialize.
	self 
	    registerNotifier;
	    extractIcons
    ]

    extractIcons [
	<category: 'initialize-release'>

	| package |
	package := PackageLoader packageAt: 'VisualGST'.
	categoryIcon := GTK.GdkPixbuf newFromFile: (package / 'Icons/category.png') file displayString error: nil.
	namespaceIcon := GTK.GdkPixbuf newFromFile: (package / 'Icons/namespace.png') file displayString error: nil.
    ]

    childrenBlock [
	<category: 'accessing'>

        ^ [ :item | self appendNamespace: item to: OrderedCollection new ]
    ]

    findBlock [
	<category: 'accessing'>

	^ [ :aLine :aNamespace | (aLine at: 2) = aNamespace displayString ]
    ]

    registerNotifier [
	<category: 'initialize-release'>

	(SystemChangeNotifier uniqueInstance)
            notify: self ofSystemChangesOfItem: #namespace change: #Added using: #'addEvent:';
            notify: self ofSystemChangesOfItem: #namespace change: #Removed using: #'removeEvent:';
            notify: self ofSystemChangesOfItem: #class change: #Recategorized using: #'recategorizedClassEvent:'
    ]

    appendNamespace: aNamespace to: anArray [
	<category: 'model builder'>

	| iter |
	anArray add: ({namespaceIcon copyNotFinalized. aNamespace displayString. aNamespace. 'N'}->(iter := OrderedCollection new)).

	(aNamespace subspaces collect: [ :each | each name ]) asSortedCollection
	    do: [ :each | self appendNamespace: (aNamespace at: each) to: iter ].
	self appendCategoriesOf: aNamespace into: iter.

	^ anArray
    ]

    appendCategoriesOf: aNamespace into: anArray [
	<category: 'model builder'>

	| classes |
	classes := aNamespace definedKeys.
	classes := classes select: [ :each | (aNamespace at: each) isClass ].
	(classes collect: [ :each | (aNamespace at: each) category ])
	    asSortedCollection
		do: [ :each | self appendCategory: each for: aNamespace into: anArray ]
    ]

    appendCategory: aString for: aNamespace into: anArray [
        <category: 'model builder'>

	| child token iter |
        token := aString ifNil: [ #() ] ifNotNil: [ aString tokenize: '-' ].
	token isEmpty ifTrue: [ ^ self ].

	child := anArray.
	token do: [ :each |
	    (child anySatisfy: [ :assoc | iter := assoc value. (assoc key at: 2) = each ]) ifFalse: [
		child add: ({categoryIcon copyNotFinalized. each. nil. 'C'}->(iter := OrderedCollection new)) ].
	    child := iter ]
    ]

    findIterInACategory: aString parent: aGtkIter [
        <category: 'item selection'>

        | iter path |
        iter := GTK.GtkTreeIter new.
        path := self gtkModel getPath: aGtkIter.
	path down.
	(self gtkModel getIter: iter path: path) ifFalse: [ ^ nil ].
	[ aString = (self gtkModel getOop: iter column: self class displayedNamespaceColumn) 
	    and: [ 'C' = (self gtkModel getOop: iter column: self class categoryColumn) ] ] whileFalse: [
	  path next.
	  (self gtkModel getIter: iter path: path) ifFalse: [ ^ nil ] ].
        ^ iter
    ]

    findIterInANamespace: aNamespace [
        <category: 'item selection'>

	self gtkModel itersDo: [ :iter |
	    (self gtkModel getOop: iter column: self class namespaceColumn) = aNamespace ifTrue: [ ^ iter ] ].

	^ self error: 'Namespace ', aNamespace displayString , ' not found'
    ]

    isIterNamespace: aGtkIter [
        <category: 'iter accessing'>

	^ 'N' = (self gtkModel at: aGtkIter column: self class categoryColumn)
    ]

    addEvent: anEvent [
	<category: 'model event'>

	|  parentIter previous |
	parentIter := self findIterInANamespace: anEvent item superspace.
	self gtkModel sonsOf: parentIter do: [ :iter |
	    ((self gtkModel at: iter) at: 2) > anEvent item displayString ifTrue: [
		^ self gtkModel insert: {namespaceIcon copyNotFinalized. anEvent item displayString. anEvent item. 'N'} before: iter ] ]
    ]

    removeEvent: anEvent [
        <category: 'model event'>

        self remove: anEvent item
    ]

    recategorizedClassEvent: anEvent [
	<category: 'model event'>

	| iter namespace |
	namespace := anEvent item environment.
        iter := self findIterInANamespace: namespace.
	self appendCategory: anEvent item category for: namespace into: iter
    ]

]

