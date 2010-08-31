GtkConcreteWidget subclass: GtkPackageBuilderWidget [

    | packName namespace provide test classCategory entries |

    initialize [
        <category: 'initialization'>

	entries := Dictionary new.
        self mainWidget: self buildMainWidget
    ]

    buildMainWidget [
        <category: 'user interface'>

        ^ (GTK.GtkVBox new: false spacing: 0)
            add: self buildPackageNameEntry mainWidget;
	    add: self buildNamespaceEntry mainWidget;
	    add: self buildPrereqEntry;
	    add: self buildProvideEntry mainWidget;
	    add: self buildTestsEntry mainWidget;
	    add: self buildClassCategoryEntry mainWidget;
	    add: self buildFilesEntry;
	    add: self buildRessourcesEntry;
            yourself
    ]

    buildList: aSymbol labeled: aString [

	| widget |
	entries
            at: aSymbol
	    put: (widget := (GTK.GtkTreeView createListWithModel: {{GtkColumnTextType title: aString}})
				    connectSignal: 'button-press-event' to: self selector: #'onPress:event:';
				    yourself).
        widget getSelection setMode: GTK.Gtk gtkSelectionBrowse.
        (GtkListModel on: widget getModel)
                                        contentsBlock: [ :each | {each displayString} ].
        ^ GTK.GtkScrolledWindow withChild: widget
    ]

    buildPackageNameEntry [
        <category: 'user interface'>

        | completion model |
        completion := GTK.GtkEntryCompletion new.
        completion 
            setModel: (model := GTK.GtkListStore createModelWith: {{GtkColumnTextType title: ''}});
            setTextColumn: 0.
	Smalltalk.PackageLoader root do: [ :each | model appendItem: {each name} ].
	^ packName := (GtkEntryWidget labeled: 'Package name :')
						completion: completion;
                                                yourself
    ]

    buildNamespaceCompletion: model [

	self buildNamespaceCompletion: Smalltalk on: model
    ]

    buildNamespaceCompletion: aNamespace on: model [

	model appendItem: {aNamespace name asString}.
	aNamespace subspaces do: [ :each |
	    self buildNamespaceCompletion: each on: model ]
    ]

    buildNamespaceEntry [
        <category: 'user interface'>

	| completion model |
	completion := GTK.GtkEntryCompletion new.
	completion 
	    setModel: (model := GTK.GtkListStore createModelWith: {{GtkColumnTextType title: ''}});
	    setTextColumn: 0.
	self buildNamespaceCompletion: model.
	^ namespace := (GtkEntryWidget labeled: 'Namespace :')
						completion: completion;
						yourself
    ]

    buildPrereqEntry [
        <category: 'user interface'>

	^ self buildList: #prereq labeled: 'Packages prerequired :'
    ]

    buildProvideEntry [
        <category: 'user interface'>

	^ provide := GtkEntryWidget labeled: 'Provides :'
    ]

    buildTestsEntry [
        <category: 'user interface'>

	^ test := GtkEntryWidget labeled: 'Tests :'
    ]

    buildClassCategoryCompletion: model [

	| set |
	set := Set new.
	Class allSubclassesDo: [ :each |
	    (set includes: each category)
		ifFalse: [
		    set add: each category.
		    model appendItem: {each category} ] ]
    ]

    buildClassCategoryEntry [
        <category: 'user interface'>

        | completion model |
        completion := GTK.GtkEntryCompletion new.
        completion
            setModel: (model := GTK.GtkListStore createModelWith: {{GtkColumnTextType title: ''}});
            setTextColumn: 0.
        self buildClassCategoryCompletion: model.
        ^ packName := (GtkEntryWidget labeled: 'Class category :')
                                                completion: completion;
                                                yourself
    ]

    buildFilesEntry [
        <category: 'user interface'>

	^ self buildList: #classes labeled: 'Classes category :'
    ]

    buildRessourcesEntry [
        <category: 'user interface'>

	^ self buildList: #ressources labeled: 'Ressources :'
    ]
]

