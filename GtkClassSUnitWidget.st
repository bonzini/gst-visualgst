GtkCategorizedClassWidget subclass: GtkClassSUnitWidget [

    addToModel: aClass [

        (aClass superclass environment == self namespace and: [ (aClass superclass category = self category or: [ self category isEmpty ]) and: [ aClass superclass ~~ Smalltalk.TestCase ] ]) 
                    ifFalse: [ model append: aClass class ]
                    ifTrue: [ model append: aClass class parent: aClass superclass class ]
    ]

    onPress: aGtkWidget event: aGdkEvent [
        <category: 'button event'>

        | menu aGdkButtonEvent |
        aGdkButtonEvent := aGdkEvent castTo: GTK.GdkEventButton type.
        aGdkButtonEvent button value = 3 ifFalse: [ ^ false ].
        menu := GTK.GtkMenu new.
        menu appendMenuItems: {{'Run tests'. self. #runTests}.
            {}.
            {'Add a class'. self. #newClass}.
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

    root [
	<category: 'accessing'>

        ^ Smalltalk.TestCase
    ]

    selectionMode [
        <category: 'accessing'>

        ^ GTK.Gtk gtkSelectionMultiple
    ]

    allClassNames [
        <category: 'accessing'>

	| classes names |
	classes := self selectedClasses.
	names := classes collect: [ :each | each name asString ].
	^ names fold: [ :a :b | a, ', ', b ]
    ]

    hasSelectedClass [
        <category: 'testing'>

        ^ (classesTree treeView getSelection getSelectedRows: nil) ~= nil
    ]

    selectedClass [
        <category: 'accessing'>

	^ self selectedClasses first
    ]

    selectedClasses [
        <category: 'accessing'>

	self hasSelectedClass ifFalse: [ self error: 'Nothing is selected' ].
	^ classesTree treeView selections collect: [:each| each asClass]
    ]

    recategorizedEvent: anEvent [
        <category: 'model event'>

        (anEvent item inheritsFrom: TestCase) ifFalse: [ ^ self ].
        super recategorizedEvent: anEvent
    ]

    addEvent: anEvent [
        <category: 'model event'>

        (anEvent item inheritsFrom: TestCase) ifFalse: [ ^ self ].
        super addEvent: anEvent
    ]

    state [
        <category: 'testing'>

        self hasSelectedClass ifTrue: [ ^ CategoryState with: self selectedClass->'*' ].
        ^super state
    ]

    runTests [ 
        <category: 'class events'> 
 
        "TODO: Change to a Command."
        self browser runSuite: self suite
    ] 

    suite [
        <category: 'run events'>

        | suite class |
        self state hasSelectedClass ifFalse: [ ^TestSuite named: 'empty'].

        suite := TestSuite named: self allClassNames.
        self selectedClasses do: [ :elem |
            elem selectors do: [ :each |
                (each matchRegex: 'test' from: 1 to: 4)
                    ifTrue: [ suite addTest: (elem selector: each) ] ] ].
        ^suite
    ]

]

