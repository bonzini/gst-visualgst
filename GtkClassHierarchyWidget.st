GtkConcreteWidget subclass: GtkClassHierarchyWidget [
    | classesTree model classOrMeta |

    GtkClassHierarchyWidget >> on: aClass [
	<category: 'instance creation'>

	^ (self new)
	    initialize;
	    classOrMeta: aClass;
	    yourself
    ]

    initialize [
	<category: 'initialization'>

	self 
	    mainWidget: self buildTreeView;
	    registerNotifier
    ]

    registerNotifier [
        <category: 'initialize-release'>

       " (VisualGST uniqueInstance systemChangeNotifier)
            notify: self ofSystemChangesOfItem: #class change: #Added using: #'addEvent:';
            notify: self ofSystemChangesOfItem: #class change: #Removed using: #'removeEvent:';
            notify: self ofSystemChangesOfItem: #class change: #Recategorized using: #'recategorizedEvent:'
   " ]

    classOrMeta [
	<category: 'accessing'>
    
	^ classOrMeta
    ]

    classOrMeta: aClass [
	<category: 'accessing'>

	classOrMeta := aClass.
	model 
	    item: aClass;
	    refresh
    ]

    emptyModel [
    ]

    appendClass: aClass to: anArray [
        <category: 'model builder'>

        anArray add: aClass 
    ]

    buildTreeView [
	<category: 'user interface'>
   
        classesTree := (GTK.GtkTreeView createTreeWithModel: {{GtkColumnTextType title: 'Classes'}})
                            connectSignal: 'button-press-event' to: self selector: #'onPress:event:' userData: nil;
                            yourself.
        classesTree getSelection setMode: GTK.Gtk gtkSelectionBrowse.
        (model := GtkTreeModel on: classesTree getModel)
                                        item: Class;
                                        childrenBlock: [ :each | | col |
                                                            col := SortedCollection sortBlock: [ :a :b | a asClass name <= b asClass name ].
                                                            each subclassesDo: [ :subclasses | self appendClass: subclasses to: col ].
                                                            col  ];
                                        contentsBlock: [ :each | {each asClass name asString, ' '} ].
        ^ GTK.GtkScrolledWindow withChild: classesTree 
    ]

    whenSelectionChangedSend: aSelector to: anObject [
	<category: 'events'>

	"classesTree getSelection
	    connectSignal: 'changed' to: anObject selector: aSelector userData: nil"
    ]

    hasSelectedClass [
	<category: 'testing'>

	^ classesTree hasSelectedItem
    ]

    selectedClass [
	<category: 'accessing'>

	| iter string |
	(iter := classesTree selectedIter) ifNil: [ ^ self classOrMeta " self error: 'Nothing is selected' " ].
	string := ((self model getOop: iter column: 0) subStrings: $ ) at: 1.

	^ self lookFor: 1 inside: Smalltalk with: (string subStrings: $.) 
    ]

    lookFor: anInteger inside: aNamespace with: anArray [
	<category: 'private'>

	anInteger < anArray size
	    ifTrue: [ aNamespace subspacesDo: [ :each |
		each name = (anArray at: anInteger) asSymbol
		    ifTrue: [ ^ self lookFor: anInteger + 1 inside: each with: anArray ] ].
		self error: 'Namespace not found' ]
	    ifFalse: [ ^ aNamespace at: (anArray at: anInteger) asSymbol ifAbsent: [ self error: 'Class not found' ] ]
    ]
]

