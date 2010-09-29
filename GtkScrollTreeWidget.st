GtkConcreteWidget subclass: GtkScrollTreeWidget [

    GtkScrollTreeWidget class >> createListWithModel: anObject [
	<category: 'instance creation'>

	^ self basicNew
		treeView: (GTK.GtkTreeView createListWithModel: anObject);
		initialize;
		yourself
    ]

    | treeView |

    initialize [
	<category:'initialize'>

	self buildTreeView.
	self mainWidget: (GTK.GtkScrolledWindow withChild: self treeView)
    ]

    onPress: aGtkWidget event: aGdkEvent [
        <category: 'button event'>

        | menu aGdkButtonEvent |
        aGdkButtonEvent := aGdkEvent castTo: GTK.GdkEventButton type.
        aGdkButtonEvent button value = 3 ifFalse: [ ^ false ].
        menu := GTK.GtkMenu new.
	self buildPopupMenu: menu.
        menu attachToWidget: treeView detacher: nil.
        menu popup: nil parentMenuItem: nil func: nil data: nil button: 3 activateTime: aGdkButtonEvent time value.
        menu showAll.
        ^ true
    ]

    buildPopupMenu: aGtkMenu [
	<category: 'user interface'>

    ]

    buildTreeView [
	<category: 'user interface'>

    ]

    treeView: aGtkTreeView [
	<category: 'accessing'>

	treeView := aGtkTreeView.
	treeView connectSignal: 'button-press-event' to: self selector: #'onPress:event:'
    ]

    treeView [
	<category: 'accessing'>

	^ treeView
    ]
]

