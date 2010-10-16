GtkConcreteWidget subclass: GtkHistoryWidget [
    | shell model widget |

    GtkHistoryWidget class >> new [
	<category: 'instance creation'>

	^ super new
		initialize;
		yourself
    ]

    initialize [
	<category: 'initialization'>

	self mainWidget: self buildListView
    ]

    shell [
	<category: 'accessing'>

	^shell
    ]

    shell: aBrowser [
	<category: 'accessing'>

	shell := aBrowser
    ]

    buildListView [
	<category: 'user interface'>

        widget := (GTK.GtkTreeView createListWithModel: {{GtkColumnTextType title: 'History'}})
                            connectSignal: 'button-press-event' to: self selector: #'onPress:event:';
                            yourself.
        widget getSelection setMode: GTK.Gtk gtkSelectionBrowse.
        widget getSelection connectSignal: 'changed' to: self selector: #onSelectionChanged.
        (model := GtkListModel on: widget getModel)
                                        contentsBlock: [ :each | {each displayString} ].
        ^ GTK.GtkScrolledWindow withChild: widget
    ]

    refresh: historyStack [
	<category: 'user interface'>

	model
	    item: historyStack;
	    refresh.

        widget selectNth: historyStack selectedIndex.
    ]

    onPress: aGtkWidget event: aGdkEvent [
        <category: 'button event'>

        | menu aGdkButtonEvent |
        aGdkButtonEvent := aGdkEvent castTo: GTK.GdkEventButton type.
        aGdkButtonEvent button value = 3 ifFalse: [ ^ false ].
        menu := GTK.GtkMenu new.
        menu appendMenuItems: {{'Inspect a class'. self. #inspectClass}.
            {'Open in new tab'. self. #browseTabbedClass}.
            "{'Open in new window'. self. #browseClass}"}.
        menu attachToWidget: widget detacher: nil.
        menu popup: nil parentMenuItem: nil func: nil data: nil button: 3 activateTime: aGdkButtonEvent time value.
        menu showAll.
        ^ true
    ]

    targetObject [
        <category: 'evaluation'>

        ^ self state state "ugly!!"
    ]

    inspectIt: anObject [
        <category: 'smalltalk event'>

        GtkInspector openOn: anObject
    ]

    inspectClass [
	<category: 'event'>

	widget hasSelectedItem ifFalse: [ ^ self ].
	InspectItCommand executeOn: self
    ]

    onSelectionChanged [
	<category: 'event'>

	widget hasSelectedItem ifFalse: [ ^ self ].
        model item selectedIndex = widget selectedIndex ifTrue: [^self].
        model item selectItem: widget selectedIndex.

        "maybe handle RestoreBrowserState?"
        shell currentWidgetOfBrowser updateState: self state.
        shell historyChanged
    ]

    browseTabbedClass [
	<category: 'event'>

	widget hasSelectedItem ifFalse: [ ^ self ].
        OpenTabbedBrowserCommand on: self
    ]

    state [
        <category: 'state'>

        ^model item current
    ]

    browserHasFocus [
        <category: 'Command'>

        ^true
    ]

    sourceCodeWidgetHasFocus [
        <category: 'Command'>

        ^false
    ]
]

