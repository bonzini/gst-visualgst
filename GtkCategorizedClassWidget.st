GtkTreeWidget subclass: GtkCategorizedClassWidget [

    GtkCategorizedClassWidget >> on: aNamespace [
	^ (self new)
	    initialize;
	    namespace: aNamespace;
	    yourself
    ]

    viewedItems [
        <category: 'accessing'>

        ^ #('text')
    ]

    title [
        <category: 'accessing'>

        ^ 'Classes'
    ]

    classModel [
	<category: 'initialization'>

	^ GtkCategorizedClassModel
    ]

    category [
	<category: 'accessing'>

	^ self model category
    ]

    category: aString [
	<category: 'accessing'>

	self model category: aString
    ]

    namespace [
	<category: 'accessing'>
    
	^ self model namespace
    ]

    namespace: aNamespace [
	<category: 'accessing'>

	self model namespace: aNamespace.
	listWidget expandAll
    ]

    namespace: aNamespace category: aString [
	<category: 'accessing'>

	self model
	    namespace: aNamespace category: aString.
	listWidget expandAll
    ]

    model [
	<category: 'accessing'>

	^ model ifNil: [ model := self classModel new ]
    ]

    buildPopupMenu [
        <category: 'popup event'>

        ^ GTK.GtkMenu new
	    appendMenuItems: {{'Add a class'. self. #newClass}.
	    {'Rename a class'. self. #renameClass}.
	    {'Delete a class'. self. #deleteClass}.
	    {}.
	    {'Inspect a class'. self. #inspectClass}.
	    {}.
	    {'File out a class'. self. #fileoutClass}};
	    yourself
    ]

    selectionMode: aSelectionMode [
	<category: 'user interface'>

	listWidget getSelection setMode: aSelectionMode.
    ]

    selectedNamespace [
	<category: 'accessing'>

	^ self model namespace
    ]

    hasSelectedClass [
	<category: 'testing'>

	^ classesTree hasSelectedItem
    ]

    selectedClass [
	<category: 'accessing'>

	| iter string |
	(iter := self selectedIter) ifNil: [self error: 'Nothing is selected'].
	string := ((self model gtkModel getOop: iter column: 0) subStrings: $ ) at: 1.
	^ self namespace classAt: string asSymbol
    ]

    selectAClass: aClass [
	<category: 'item selection'>

	| selection |
        selection := classesTree getSelection.
        selection unselectAll.
        selection selectIter: (self findIterInAClass: aClass)
    ]

    findIterInAClass: aClass [
        <category: 'item selection'>

	| result |

	result := self model findIterInAClass: aClass.
	classesTree scrollToCell: (self model gtkModel getPath: result) column: nil useAlign: false rowAlign: 0.5 colAlign: 0.5.
	^ result 
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

    category: aString [
	<category: 'accessing'>

	category := aString.
    ]

    category [
	<category: 'accessing'>

	^ category
    ]

    namespace: aNamespace category: aString [
	<category: 'accessing'>

	self
	    category: aString;
	    namespace: aNamespace
    ]

]

