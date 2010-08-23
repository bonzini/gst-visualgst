GtkConcreteWidget subclass: GtkSidebarWidget [
    | activeWidget widgets paned |

    initialize [

	paned := GTK.GtkHPaned new.
	self mainWidget: paned.
	activeWidget := GtkAbstractConcreteWidget new.
	widgets := OrderedCollection new
    ]

    postInitialize [

	self hideAll
    ]

    add: aGtkWidget [

	| p |
	widgets add: aGtkWidget.
	p := GTK.GtkHPaned new.
	paned
	    pack1: aGtkWidget resize: true shrink: true;
	    pack2: p resize: true shrink: true.
	paned := p
    ]

    addAll: anArray [

	anArray do: [ :each | self add: each ]
    ]

    show: anIndex [

	activeWidget hideAll.
	activeWidget := (widgets at: anIndex)
					showAll;
					yourself
    ]

    showAll [

	widgets do: [ :each | each showAll ]
    ]

    hide [

	activeWidget hideAll
    ]

    hideAll [

	widgets do: [ :each | each hideAll ]
    ]

    panedOrientation [

	^ self subclassResponsibility
    ]
]

