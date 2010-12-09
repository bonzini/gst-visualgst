GtkConcreteWidget subclass: GtkClassHierarchyWidget [
    | dic classOrMeta classesTree model |

    GtkClassHierarchyWidget class >> on: aClass [
	<category: 'accessing'>

        ^self new classOrMeta: aClass; yourself
    ]

    classOrMeta: aClass [
	<category: 'accessing'>

        classOrMeta := aClass
    ]

    initialize [
	<category: 'initialization'>

	dic := Dictionary new.
	self 
	    mainWidget: self buildTreeView;
	    registerNotifier
    ]

    registerNotifier [
        <category: 'initialize-release'>

       " (GtkLauncher uniqueInstance systemChangeNotifier)
            notify: self ofSystemChangesOfItem: #class change: #Added using: #'addEvent:';
            notify: self ofSystemChangesOfItem: #class change: #Removed using: #'removeEvent:';
            notify: self ofSystemChangesOfItem: #class change: #Recategorized using: #'recategorizedEvent:'
   " ]

    subclassesOf: superclass [
        ^dic at: superclass ifAbsentPut: [
            superclass subclasses asSortedCollection:
                [ :a :b | a asClass name <= b asClass name ] ].
    ]

    refresh [
	| parent roots |

	dic := Dictionary new.
        roots := classOrMeta isNil
            ifTrue: [Class subclasses]
            ifFalse: [{classOrMeta asMetaclass}].
        dic at: #root put:
            (Class subclasses asSortedCollection:
                [ :a :b | a asClass name <= b asClass name ]).
        model refresh
    ]

    buildTreeView [
	<category: 'user interface'>
   
        classesTree := GTK.GtkTreeView createTreeWithModel: {{GtkColumnTextType title: 'Classes'}}.
        classesTree getSelection setMode: GTK.Gtk gtkSelectionBrowse.
        (model := GtkTreeModel on: classesTree getModel)
                                        item: #root;
                                        childrenBlock: [ :each |
                                            self subclassesOf: each  ];
                                        contentsBlock: [ :each | {each asClass name asString, ' '} ].

	self refresh.
	classesTree expandAll.
        ^ GTK.GtkScrolledWindow withChild: classesTree
    ]

    whenSelectionChangedSend: aSelector to: anObject [
	<category: 'events'>

	classesTree getSelection
	    connectSignal: 'changed' to: anObject selector: aSelector
    ]

    hasSelectedClass [
	<category: 'testing'>

	^ classesTree hasSelectedItem
    ]

    selectAClass: aClass [
	<category: 'item selection'>

	classesTree select: aClass
    ]

    selectedClass [
	<category: 'accessing'>

	self hasSelectedClass ifFalse: [ self error: 'Nothing is selected' ].
	^ classesTree selection asClass
    ]

    state [
        <category: 'testing'>

        self hasSelectedClass ifTrue: [ ^ ClassState with: self selectedClass ].
        ^ BrowserState new
    ]

    updateBrowser: aGtkClassBrowserWidget [
        <category: 'events'>

	self hasSelectedClass ifFalse: [ ^ self ].
	aGtkClassBrowserWidget updateClassHierarchyWidget
    ]
]

