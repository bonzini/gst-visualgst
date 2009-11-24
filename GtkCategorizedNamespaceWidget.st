GtkTreeWidget subclass: GtkCategorizedNamespaceWidget [
    namespace: aNamespace [
	<category: 'accessing'>

	self model namespace: aNamespace
    ]

    namespace [
	<category: 'accessing'>

	^ self model namespace
    ]

    category: aString [
	<category: 'accessing'>

	self model category: aString
    ]

    category [
	<category: 'accessing'>

	^ self model category
    ]

    namespace: aNamespace category: aString [
	<category: 'accessing'>

	self model namespace: aNamespace category: aString
    ]

    sortedColumn [
	<category: 'accessing'>

	^ 1
    ]

    viewedItems [
	<category: 'accessing'>

	^ #('pixbuf' 'text')
    ]

    title [
	<category: 'accessing'>

	^ 'Namespaces'
    ]

    model [
	<category: 'accessing'>

	^ model ifNil: [
	    model := GtkCategorizedNamespaceModel new.

	    model gtkModel
		connectSignal: 'row-has-child-toggled' to: self
		selector: #'childToggled:path:iter:'.

	    model
	 ]
    ]

    selectedNamespace [
	<category: 'accessing'>

	| iter path |
	(self model isIterNamespace: self selectedIter) ifTrue: [ 
	    ^ self model gtkModel getOop: self selectedIter column: 2 ].
	path := self model gtkModel getPath: self selectedIter.
	iter := GTK.GtkTreeIter new.
	[ path up.
	  (self model gtkModel getIter: iter path: path) ifFalse: [ self error: 'Selected category not found' ].
	  (self model isIterNamespace: iter) ] whileFalse.
	^ self model gtkModel getOop: iter column: 2
    ]

    selectedCategory [
	<category: 'accessing'>

	| iter path cat |
	(self model isIterNamespace: self selectedIter) ifTrue: [ ^ '' ].
	path := self model gtkModel getPath: self selectedIter.
        iter := GTK.GtkTreeIter new.
	cat := self model gtkModel getOop: self selectedIter column: 1.
        [ path up.
          (self model gtkModel getIter: iter path: path) ifFalse: [ self error: 'Selected category not found' ].
          (self model isIterNamespace: iter) ] whileFalse:
	      [ cat := (self model gtkModel getOop: iter column: 1), '-', cat ].
	^ cat
    ]

    childToggled: model path: path iter: iter [
	<category: 'signals'>

	listWidget collapseRow: path.
	(self model isIterNamespace: iter)
	    ifTrue: [
		(path castTo: GTK.GtkTreePath type) up.
		listWidget expandRow: path openAll: false ]
    ]

    buildPopupMenu [
	<category: 'popup event'>

	^ GTK.GtkMenu new
	    appendMenuItems: {{'Add a namespace'. self. #newNamespace}.
	    {'Rename a namespace'. self. #renameNamespace}.
	    {'Delete a namespace'. self. #deleteNamespace}.
	    {}.
	    {'Inspect a namespace'. self. #inspectNamespace}.
	    {}.
	    {'File out a namespace'. self. #fileoutNamespace}};
	    yourself
    ]

    newNamespace [
        <category: 'popup events'>

        AddNamespaceCommand on: self
    ]

    renameNamespace [
        <category: 'namespace events'>

        RenameNamespaceCommand on: self
    ]

    deleteNamespace [
        <category: 'namespace events'>

        DeleteNamespaceCommand on: self
    ]

    inspectNamespace [
        <category: 'namespace events'>

        InspectNamespaceCommand on: self
    ]

    fileoutNamespace [
        <category: 'namespace events'>

        FileoutNamespaceCommand on: self selectedNamespace
    ]
]

