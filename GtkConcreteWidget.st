Smalltalk.Object subclass: GtkConcreteWidget [
    | child |
    
    mainWidget [
	<category: 'accessing'>

	^ child
    ]

    mainWidget: aGtkWidget [
	<category: 'accessing'>

	child ifNotNil: [child hideAll].
	child := aGtkWidget
    ]

    showAll [
	<category: 'user interface'>

	child showAll
    ]
]
