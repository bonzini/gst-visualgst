GtkConcreteWidget subclass: GtkImplementorResults [
    | result resultTree model |

    initialize [
        <category: 'initialization'>

        self mainWidget: self buildTreeView
    ]

    buildTreeView [
        <category: 'user interface'>

        resultTree := GTK.GtkTreeView createListWithModel: {{GtkColumnTextType title: 'Methods and Classes'}}.
        resultTree getSelection setMode: GTK.Gtk gtkSelectionBrowse.
        (model := GtkListModel on: resultTree getModel)
                                        contentsBlock: [ :each | {each asString} ].
        ^ GTK.GtkScrolledWindow withChild: resultTree
    ]

    whenSelectionChangedSend: aSelector to: anObject [
        <category: 'events'>

        resultTree getSelection
            connectSignal: 'changed' to: anObject selector: aSelector
    ]

    clear [
        <category: 'accessing'>

        model clear
    ]

    hasSelectedResult [
        <category: 'testing'>

        ^ resultTree hasSelectedItem
    ]

    selectedResult [
        <category: 'accessing'>

        self hasSelectedResult ifFalse: [ ^ self error: 'nothing is selected' ].
        ^ resultTree selection
    ]

    appendImplementorResults: aDictionary [

	self clear.
        model contentsBlock: [ :each | {each key asString} ].
	aDictionary associationsDo: [ :each |
	    model append: each ]
    ]

    appendSenderResults: aDictionary [

	self clear.
	model contentsBlock: [ :each | {each displayString} ].
	self findInMethod: aDictionary values first element
    ]

    literalsAndSpecialSelectors [
        <category: 'accessing'>

        ^  GtkSender literalsAndSpecialSelectors
    ]

    findInMethod: anObject [
        <category: 'find'>

        (self literalsAndSpecialSelectors at: anObject displaySymbol ifAbsent: [ #() ] ) do: [ :each |
            model append: each ].
    ]
]

