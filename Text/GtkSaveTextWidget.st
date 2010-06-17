GtkTextPluginWidget subclass: GtkSaveTextWidget [ 
    | cancel label save state |

    buildCancelButton [
	<category: 'user interface'>

        ^ cancel := GTK.GtkButton newWithLabel: 'Cancel'
    ]

    buildSaveButton [
        <category: 'user interface'>

        ^ save := GTK.GtkButton newWithLabel: 'Save'
    ]

    hBox [
	<category: 'user interface'>

	^ super hBox
	    packStart: (GTK.GtkLabel new: 'Save the code before exiting?') expand: false fill: false padding: 2;
	    packStart: (label := GTK.GtkLabel new: '') expand: false fill: false padding: 2;
	    packStart: self buildSaveButton expand: false fill: false padding: 0; 
	    packStart: self buildCancelButton expand: false fill: false padding: 0;
	    yourself
    ]

    state [
	<category: 'state'>

	^state
    ]

    state: aState [
	<category: 'state'>

	state := aState.
    ]

    grabFocus [
	<category: 'focus'>

	cancel grabFocus
    ]

    showAll [
	<category: 'user interface'>

	label setText: 'If you do not save, your changes to %1 will be lost...' % {self state}.
	super showAll
    ]

    whenCancelPressed: aSymbol to: anObject [
	<category: 'user interface'>

	cancel
	    connectSignal: 'pressed' to: anObject selector: aSymbol
    ]

    whenSavePressed: aSymbol to: anObject [
	<category: 'user interface'>

	save	
	    connectSignal: 'pressed' to: anObject selector: aSymbol
    ]
]

