GtkConcreteWidget subclass: GtkStackInspectorView [
    | object model |

    GtkStackInspectorView class >> openOn: aContext [
	<category: 'instance creation'>

	^ (super new)
	    object: aContext;
	    yourself
    ]

    object [
	<category: 'accessing'>
	
	^ object
    ]

    object: anObject [
	<category: 'accessing'>

	object := anObject.
	self refreshModel
    ]

    model [
	<category: 'accessing'>

	^ model ifNil: [
	    model := GTK.GtkListStore new: 1 varargs: {GTK.GValue gTypeString} ]
    ]

    clearModel [
        <category: 'accessing'>

        self model clear
    ]

    refreshModel [
	<category: 'events'>
   
	self clearModel.
	self appendVariable: 'thisContext'.
	self object variablesDo: [ :each |
		self appendVariable: each displayString ]
    ]

    appendVariable: aString [
        <category: 'model builder'>

        | iter |
        iter := GTK.GtkTreeIter new.
        self model append: iter.
        self model setOop: iter column: 0 value: aString
    ]

    selectedValue: aString [
	<category: 'item selection'>

	| iter string instVar |
        ^ aString = 'thisContext'
            ifTrue: [ self object ]
            ifFalse: [ self object at: 1  ]
    ]

    canDive [
	<category: 'testing'>

	^ false
    ]
]

