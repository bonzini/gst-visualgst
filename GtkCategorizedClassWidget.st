GtkConcreteWidget subclass: GtkCategorizedClassWidget [
    | classesTree column model namespace category |

    GtkCategorizedClassWidget >> on: aNamespace [
	^ (self new)
	    initialize;
	    namespace: aNamespace;
	    yourself
    ]

    initialize [
	<category: 'initialization'>

	category := ''.
	self 
	    mainWidget: self buildTreeView;
	    registerNotifier
    ]

    registerNotifier [
        <category: 'initialize-release'>

        (VisualGST uniqueInstance systemChangeNotifier)
            notify: self ofSystemChangesOfItem: #class change: #Added using: #'addEvent:';
            notify: self ofSystemChangesOfItem: #class change: #Removed using: #'removeEvent:';
            notify: self ofSystemChangesOfItem: #class change: #Recategorized using: #'recategorizedEvent:'
    ]

    category: aString [
        <category: 'accessing'>

        category := aString.
    ]

    category [
        <category: 'accessing'>

        ^ category
    ]

    namespace [
	<category: 'accessing'>
    
	^ namespace
    ]

    namespace: aNamespace [
	<category: 'accessing'>

	namespace := aNamespace.
    ]

    namespace: aNamespace category: aString [
        <category: 'accessing'>

	(aNamespace == self namespace and: [ aString = self category ]) ifTrue: [ ^ self ]. 
        self
            category: aString;
            namespace: aNamespace.
	model refresh.
	classesTree expandAll
    ]

    appendClass: aClass to: anArray [
        <category: 'model builder'>

        (aClass environment = self namespace and: [ self category isEmpty or: [ self category = aClass category or: [ (self namespace displayString, '-', self category) = aClass category ] ] ]) 
		    ifTrue: [ anArray add: aClass ]
		    ifFalse: [ aClass subclassesDo: [ :each | self appendClass: each to: anArray ] ]
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
							    col ];
                                        contentsBlock: [ :each | {each asClass name asString, ' '} ].
        ^ GTK.GtkScrolledWindow withChild: classesTree 
    ]

    onPress: aGtkWidget event: aGdkEvent [
        <category: 'button event'>

        | menu aGdkButtonEvent |
        aGdkButtonEvent := aGdkEvent castTo: GTK.GdkEventButton type.
        aGdkButtonEvent button value = 3 ifFalse: [ ^ false ].
        menu := GTK.GtkMenu new.
        menu appendMenuItems: {{'Add a class'. self. #newClass}.
            {'Rename a class'. self. #renameClass}.
            {'Delete a class'. self. #deleteClass}.
            {}.
            {'Inspect a class'. self. #inspectClass}.
            {}.
            {'File out a class'. self. #fileoutClass}}.
        menu attachToWidget: classesTree detacher: nil.
        menu popup: nil parentMenuItem: nil func: nil data: nil button: 3 activateTime: aGdkButtonEvent time value.
        menu showAll.
        ^ true
    ]

    whenSelectionChangedSend: aSelector to: anObject [
	<category: 'events'>

	classesTree getSelection
	    connectSignal: 'changed' to: anObject selector: aSelector userData: nil
    ]

    selectionMode: aSelectionMode [
	<category: 'user interface'>

	classesTree getSelection setMode: aSelectionMode.
    ]

    selectedNamespace [
	<category: 'accessing'>

	^ namespace
    ]

    hasSelectedClass [
	<category: 'testing'>

	^ classesTree hasSelectedItem
    ]

    selectedClass [
	<category: 'accessing'>

	self hasSelectedClass ifFalse: [ self error: 'nothing is selected' ].
	^ classesTree selection asClass
    ]

    selectAClass: aClass [
	<category: 'item selection'>

	classesTree select: aClass
    ]

    newClass [
        <category: 'class events'>

        AddClassCommand on: self
    ]

    renameClass [
        <category: 'class events'>

        RenameClassCommand on: self
    ]

    deleteClass [
        <category: 'class events'>

        DeleteClassCommand on: self
    ]

    inspectClass [
        <category: 'class events'>

	InspectClassCommand on: self
    ]

    fileoutClass [
        <category: 'class events'>

	FileoutClassCommand on: self selectedClass
    ]

    addEvent: anEvent [
        <category: 'model event'>

        | parentIter parent |
        anEvent item environment == self namespace ifFalse: [ ^ self ].
        (anEvent item category = self category or: [ self category isEmpty ]) ifFalse: [ ^ self ].
	model append: anEvent item parent: anEvent item superclass class
    ]

    removeEvent: anEvent [
        <category: 'model event'>

        anEvent item environment == self namespace ifFalse: [ ^ self ].
        (anEvent item category = self category or: [ self category isEmpty ]) ifFalse: [ ^ self ].
        model remove: anEvent item
    ]

    recategorizedEvent: anEvent [
        <category: 'model event'>

       | iter |
        anEvent item environment == self namespace ifFalse: [ ^ self ].
        anEvent oldCategory = anEvent item category ifTrue: [ ^ self ].
        (anEvent oldCategory = self category or: [ self category isEmpty ]) ifTrue: [ ^ self remove: anEvent item ].
        (anEvent item category = self category or: [ self category isEmpty ]) ifTrue: [
            iter := self findIterInAClass: anEvent item superclass ifAbsent: [ nil ].
            self append: iter column: 0 value: (anEvent item name, ' ') ].
    ]
]

