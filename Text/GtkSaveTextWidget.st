GtkTextPluginWidget subclass: GtkSaveTextWidget [ 
    | cancel cancelMessage label save saveMessage state |

    buildCancelButton [
	<category: 'user interface'>

        ^(cancel := GTK.GtkButton newWithLabel: 'Cancel')
	    connectSignal: 'pressed' to: self selector: #onCancel;
            yourself
    ]

    buildSaveButton [
        <category: 'user interface'>

        ^(save := GTK.GtkButton newWithLabel: 'Save')
	    connectSignal: 'pressed' to: self selector: #onSave;
            yourself
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

    onSave [
	<category: 'button events'>

        saveMessage isNil ifFalse: [ saveMessage send ].
        textWidget hideSave; clearUndo.
    ]

    onCancel [
	<category: 'button events'>

        cancelMessage isNil ifFalse: [ cancelMessage send ].
        textWidget hideSave; clearUndo.
    ]

    whenCancelPressed: aSymbol to: anObject [
	<category: 'user interface'>

        cancelMessage := DirectedMessage receiver: anObject selector: aSymbol arguments: #().
    ]

    whenSavePressed: aSymbol to: anObject [
	<category: 'user interface'>

        saveMessage := DirectedMessage receiver: anObject selector: aSymbol arguments: #().
    ]
]

