GtkConcreteWidget subclass: GtkMethodWidget [
    | model methodTree class category |

    GtkMethodWidget >> on: aClass withCategory: aCategory [
	<category: 'instance creation'>

	^ (self new)
	    initialize;
	    class: aClass withCategory: aCategory;
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

        (VisualGST uniqueInstance systemChangeNotifier)
            notify: self ofSystemChangesOfItem: #method change: #Added using: #'addEvent:';
            notify: self ofSystemChangesOfItem: #method change: #Removed using: #'removeEvent:'
    ]

    category [
	<category: 'accessing'>

	^ category
    ]

    category: aString [
	<category: 'accessing'>

	category := aString.
	model 
	    item: (self classOrMeta methodDictionary select: [ :each | self category = '*' or: [ each methodCategory = self category ] ]);
	    refresh
    ]

    classOrMeta [
	<category: 'accessing'>

	^ class
    ]

    class: aClass withCategory: aString [
	<category: 'accessing'>

	class := aClass.
	self category: aString
    ]

    gtkModel [
	^ methodTree getModel
    ]

    emptyModel [
        <category: 'accessing'>

	self clear
    ]

    clear [
	methodTree getModel clear
    ]

    appendMethod: aString [
        <category: 'model builder'>

        (self findIterInAMethod: aString) ifNotNil: [ ^ self ].
        self gtkModel appendItem: {aString}
    ]

    removeMethod: aString [
        <category: 'model builder'>

        | iter |
        (iter := self findIterInAMethod: aString) ifNil: [ ^ self ].
        self gtkModel remove: iter
    ]

    includesCategory: aSymbol [
        <category: 'testing'>

        self category = '*' ifTrue: [ ^ true ].
        (self category = 'still unclassified' and: [ aSymbol isNil ]) ifTrue: [ ^ true ].
        ^ self category = aSymbol
    ]

    buildTreeView [
        <category: 'user interface'>
    
	methodTree := (GTK.GtkTreeView createListWithModel: {{GtkColumnTextType title: 'Methods'}})
                            connectSignal: 'button-press-event' to: self selector: #'onPress:event:' userData: nil;
                            yourself.
	methodTree getSelection setMode: GTK.Gtk gtkSelectionBrowse.
	(model := GtkListModel on: methodTree getModel)
					contentsBlock: [ :each | {each selector asString} ].
	^ GTK.GtkScrolledWindow withChild: methodTree
    ]

    isTestMethod [
	<category: 'button event'>

	^ (self classOrMetaSelected inheritsFrom: TestCase)
	    and: [ self selectedMethodSymbol startsWith: 'test' ]
    ]

    onPress: aGtkWidget event: aGdkEvent [
        <category: 'button event'>

        | menu aGdkButtonEvent |
        aGdkButtonEvent := aGdkEvent castTo: GTK.GdkEventButton type.
        aGdkButtonEvent button value = 3 ifFalse: [ ^ false ].
        menu := GTK.GtkMenu new.
	self isTestMethod ifTrue: [
            menu appendMenuItems: {{'Run test'. self. #runTest}} ].
        menu appendMenuItems: {{'Browse senders'. self. #browseSenders}.
	    {'Browse implementors'. self. #browseImplementors}.
	    {}.
	    {'Rename method'. self. #renameMethod}.
            {'Delete method'. self. #deleteMethod}.
            {}.
            {'Inspect method'. self. #inspectMethod}.
            {}.
            {'File out method'. self. #fileoutMethod}}.
        menu attachToWidget: methodTree detacher: nil.
        menu popup: nil parentMenuItem: nil func: nil data: nil button: 3 activateTime: aGdkButtonEvent time value.
        menu showAll.
        ^ true
    ]

    whenSelectionChangedSend: aSelector to: anObject [
	<category: 'events'>

	methodTree getSelection
	    connectSignal: 'changed' to: anObject selector: aSelector userData: nil
    ]

    classOrMetaSelected [
	<category: 'accessing'>

	^ class
    ]

    selectedCategory [
	<category: 'accessing'>

	^ category = '*' 
	    ifTrue: [ nil ]
	    ifFalse: [ category ]
    ]

    hasSelectedMethod [
	<category: 'testing'>

	^ methodTree hasSelectedItem
    ]

    selectedMethodSymbol [
	<category: 'accessing'>

        | iter string |
        (iter := methodTree selectedIter) ifNil: [ ^nil ].
        ^ (self gtkModel at: iter) first asSymbol
    ]

    selectedMethod [
	<category: 'accessing'>

	| symbol |
	(symbol := self selectedMethodSymbol) ifNil: [ ^nil ].
	^ self classOrMetaSelected compiledMethodAt: symbol
    ]

    selectAMethod: aString [
        <category: 'item selection'>

        | selection |
        selection := methodTree getSelection.
        selection unselectAll.
        aString ifNil: [ ^ self ].
        selection selectIter: (self findIterInAMethod: aString)
    ]

    findIterInAMethod: aString [
        <category: 'item selection'>

        | result |

        self gtkModel do: [ :elem :iter |
            elem first = aString ifTrue: [ 
		    methodTree scrollToCell: (self gtkModel getPath: iter) column: nil useAlign: false rowAlign: 0.5 colAlign: 0.5. 
		    ^ iter ] ].
        ^ nil 
    ]

    sourceCode [
	<category: 'accessing'>

	self hasSelectedMethod ifFalse: [ self error: 'Nothing is selected' ].
	^ (self classOrMetaSelected compiledMethodAt: self selectedMethodSymbol) methodRecompilationSourceString
    ]

    deleteMethod [
        <category: 'method events'>

        DeleteMethodCommand on: self
    ]

    inspectMethod [
        <category: 'method events'>

	InspectMethodCommand on: self
    ]

    browseSenders [
        <category: 'method events'>

	OpenSenderCommand on: self
    ]

    browseImplementors [
        <category: 'method events'>

	OpenImplementorCommand on: self
    ]

    runTest [
        <category: 'method events'>

	RunTestCommand on: self
    ]

    fileoutMethod [
        <category: 'method events'>

	FileoutMethodCommand on: self selectedMethod
    ]

    addEvent: anEvent [
        <category: 'event'>

        (anEvent item methodClass == self classOrMeta and: [ self includesCategory: anEvent item methodCategory ] ) ifFalse: [ ^ self ].
        self appendMethod: anEvent item selector asString
    ]

    removeEvent: anEvent [
        <category: 'event'>

        (anEvent item methodClass == self classOrMeta and: [ self includesCategory: anEvent item methodCategory ]) ifFalse: [ ^ self ].
        self removeMethod: anEvent item selector asString
    ]
]

