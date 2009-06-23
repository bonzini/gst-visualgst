GTK.GtkMenu extend [

    appendSeparator [
    <category: 'accessing'>

    self append: GTK.GtkMenuItem new
    ]

    appendMenuItems: anArray [
    <category: 'accessing'>

    anArray do: [ :each |
        self append: 
	(each isEmpty 
	    ifTrue: [ GTK.GtkMenuItem new ]
	    ifFalse: [ (GTK.GtkMenuItem newWithLabel: (each at: 1))
		connectSignal: 'activate' to: (each at: 2) selector: (each at: 3) userData: nil;
		yourself ]) ]
    ]
]

