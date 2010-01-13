GtkConcreteWidget subclass: GtkCategorizedNamespaceWidget [
    | categoryIcon namespaceIcon namespacesTree model |

    initialize [
        <category: 'initialization'>

        | package |
        package := PackageLoader packageAt: 'VisualGST'.
        categoryIcon := GTK.GdkPixbuf newFromFile: (package / 'Icons/category.png') file displayString error: nil.
        namespaceIcon := GTK.GdkPixbuf newFromFile: (package / 'Icons/namespace.png') file displayString error: nil.
        self mainWidget: self buildTreeView
    ]

    "model [
	<category: 'accessing'>

	    model gtkModel
		connectSignal: 'row-has-child-toggled' to: self
		selector: #childToggled:path:iter:.
    ]"

    buildTreeView [
        <category: 'user interface'>

        namespacesTree := (GTK.GtkTreeView createTreeWithModel: {{GtkColumnPixbufType visible. GtkColumnTextType title: 'Namespaces'}})
                            connectSignal: 'button-press-event' to: self selector: #'onPress:event:';
                            yourself.
        namespacesTree getSelection setMode: GTK.Gtk gtkSelectionBrowse.
        (model := GtkTreeModel on: namespacesTree getModel)
                                        item: FakeNamespace;
                                        childrenBlock: [ :each | each subspaces ];
                                        contentsBlock: [ :each | {namespaceIcon. each name asString} ];
					refresh.
	namespacesTree expandAll.
        ^ GTK.GtkScrolledWindow withChild: namespacesTree
    ]

    onPress: aGtkWidget event: aGdkEvent [
        <category: 'button event'>

        | menu aGdkButtonEvent |
        aGdkButtonEvent := aGdkEvent castTo: GTK.GdkEventButton type.
        aGdkButtonEvent button value = 3 ifFalse: [ ^ false ].
        menu := GTK.GtkMenu new.
        menu appendMenuItems: {{'Add a namespace'. self. #newNamespace}.
            {'Rename a namespace'. self. #renameNamespace}.
            {'Delete a namespace'. self. #deleteNamespace}.
            {}.
            {'Inspect a namespace'. self. #inspectNamespace}.
            {}.
            {'File out a namespace'. self. #fileoutNamespace}}.
        menu attachToWidget: namespacesTree detacher: nil.
        menu popup: nil parentMenuItem: nil func: nil data: nil button: 3 activateTime: aGdkButtonEvent time value.
        menu showAll.
        ^ true
    ]

    whenSelectionChangedSend: aSelector to: anObject [
        <category: 'events'>

        namespacesTree getSelection
            connectSignal: 'changed' to: anObject selector: aSelector
    ]

    selectANamespace: aNamespace [
        <category: 'item selection'>

	namespacesTree select: aNamespace
    ]

    hasSelectedNamespace [
        <category: 'testing'>

        ^ namespacesTree hasSelectedItem
    ]

    selectedNamespace [
        <category: 'accessing'>

	self hasSelectedNamespace ifFalse: [ self error: 'nothing is selected' ].
	^ namespacesTree selection
    ]

    selectedCategory [
        <category: 'accessing'>

	^ ''
    ]
"    selectedNamespace [
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

	namespacesTree collapseRow: path.
	(self model isIterNamespace: iter) ifTrue: [
	    ((self model gtkModel at: iter) at: 3) subspaces isEmpty ifFalse: [
		namespacesTree expandRow: path openAll: false ] ]
    ]"
]

