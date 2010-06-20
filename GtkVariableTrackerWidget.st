GtkConcreteWidget subclass: GtkVariableTrackerWidget [
    | model object widget |

    GtkVariableTrackerWidget class >> on: anObject [
	<category: 'instance creation'>

	^ self new
		initialize;
		object: anObject;
		yourself
    ]

    initialize [
	<category: 'initialization'>

	self mainWidget: self buildListView
    ]

    object: anObject [
	<category: 'accessing'>

	object := anObject.
	self refresh
    ]

    buildListView [
	<category: 'user interface'>

        widget := (GTK.GtkTreeView createListWithModel: {{GtkColumnTextType title: 'Variable'}. {GtkColumnTextType title: 'Value'}})
                            connectSignal: 'button-press-event' to: self selector: #'onPress:event:' userData: nil;
                            yourself.
        widget getSelection setMode: GTK.Gtk gtkSelectionBrowse.
        (model := GtkListModel on: widget getModel)
                                        contentsBlock: [ :each | {each asString. (object instVarNamed: each) displayString} ].
        ^ GTK.GtkScrolledWindow withChild: widget
    ]

    refresh [
	<category: 'user interface'>

	model 
	    item: object class allInstVarNames;
	    refresh
    ]
]

