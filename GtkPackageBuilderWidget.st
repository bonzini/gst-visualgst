GtkConcreteWidget subclass: GtkPackageBuilderWidget [

    | entries |

    initialize [
        <category: 'initialization'>

	entries := Dictionary new.
        self mainWidget: self buildMainWidget
    ]

    buildMainWidget [
        <category: 'user interface'>

        ^ (GTK.GtkVBox new: false spacing: 0)
            add: self buildPackageNameEntry;
	    add: self buildNamespaceEntry;
	    add: self buildPrereqEntry;
	    add: self buildProvideEntry;
	    add: self buildTestsEntry;
	    add: self buildFilesEntry;
	    add: self buildRessourcesEntry;
            yourself
    ]

    buildEntry: aSymbol labeled: aString [

	| widget |
        entries 
            at: aSymbol 
            put: (widget := GTK.GtkEntry new).
        ^ (GTK.GtkHBox new: true spacing: 3)
            add: (GTK.GtkLabel new: aString);
            add: widget;
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

	^ self buildEntry: #packName labeled: 'Package name :'
    ]

    buildNamespaceEntry [
        <category: 'user interface'>

	^ self buildEntry: #namespace labeled: 'Namespace :'
    ]

    buildPrereqEntry [
        <category: 'user interface'>

	^ self buildList: #prereq labeled: 'Packages prerequired :'
    ]

    buildProvideEntry [
        <category: 'user interface'>

	^ self buildEntry: #provide labeled: 'Provides :'
    ]

    buildTestsEntry [
        <category: 'user interface'>

	^ self buildEntry: #test labeled: 'Tests :'
    ]

    buildFilesEntry [
        <category: 'user interface'>

	^ self buildList: #files labeled: 'Files :'
    ]

    buildRessourcesEntry [
        <category: 'user interface'>

	^ self buildList: #ressources labeled: 'Ressources :'
    ]
]

