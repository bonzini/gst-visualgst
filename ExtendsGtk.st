GTK.GtkObject extend [
    signalEmit: signal args: argsArray [
        <category: 'C call-outs'>
        <cCall: 'gtk_signal_emit' returning: #void
        args: #(#self #int #variadic)>

    ]

    signalEmitByName: signal args: argsArray [
        <category: 'C call-outs'>
        <cCall: 'gtk_signal_emit_by_name' returning: #void
        args: #(#self #string #variadic)>

    ]

    signalNEmissions: signal [
        <category: 'C call-outs'>
        <cCall: 'gtk_signal_n_emissions' returning: #int
        args: #(#self #int)>

    ]

    signalNEmissionsByName: signal [
        <category: 'C call-outs'>
        <cCall: 'gtk_signal_n_emissions_by_name' returning: #int
        args: #(#self #string)>

    ]

    signalEmitStop: signal [
        <category: 'C call-outs'>
        <cCall: 'gtk_signal_emit_stop' returning: #void
        args: #(#self #int)>

    ]

    signalEmitStopByName: signal [
        <category: 'C call-outs'>
        <cCall: 'gtk_signal_emit_stop_by_name' returning: #void
        args: #(#self #string)>

    ]

]

GTK.GtkDialog extend [
    | codeblock destroy |

    runNonBlocking [
	<category: 'services'>

	destroy := false.
	self
	    setModal: true;
	    connectSignal: 'response' to: self selector: #onDialog:response: userData: nil;
	    run 
    ]

    runNonBlockingAndDo: aCodeblock [
	<category: 'services'>

	destroy := false.
	codeblock :=  aCodeblock.
	self runNonBlocking
    ]
    
    runNonBlockingAndDestroy [
	<category: 'services'>

	destroy := true.
	self runNonBlocking
    ]

    runBlocking [
	<category: 'services'>

	destroy := false.
	self
	    setModal: false;
	    connectSignal: 'response' to: self selector: #onDialog:response: userData: nil;
            run
    ]

    runBlockingAndDo: aCodeblock [
	<category: 'services'>

	destroy := false.
	codeblock := aCodeblock.
	self runBlocking
    ]

    runBlockingAndDestroy [
        <category: 'services'>

        destroy := true.
        self
            setModal: false;
            connectSignal: 'response' to: self selector: #onDialog:response: userData: nil;
            run
    ]

    onDialog: aGtkDialog response: anInteger [
	<category: 'events'>

	destroy ifTrue: [ self destroy ].
	codeblock isNil ifFalse: [ codeblock value: aGtkDialog value: anInteger ]
    ]
]

GTK.GtkScrolledWindow class extend [

    withChild: aGtkWidget [
	<category: 'instance creation'>

	^ (GTK.GtkScrolledWindow new: nil vadjustment: nil)
	    add: aGtkWidget;
	    setPolicy: GTK.Gtk gtkPolicyAutomatic vscrollbarPolicy: GTK.Gtk gtkPolicyAutomatic;
	    yourself
    ]
]

GTK.GtkFileChooserDialog class extend [

    for: aGtkFileChooserAction title: aString parent: aGtkWidget button: aGtkStock  [
	<category: 'instance creation'>

	^ self
	    new: aString
	    parent: aGtkWidget
	    action: aGtkFileChooserAction
	    varargs: {GTK.Gtk gtkStockCancel.
                    GTK.Gtk gtkResponseCancel.
		    aGtkStock.
                    GTK.Gtk gtkResponseAccept.
                    nil}
    ]

    save: aString parent: aGtkWidget [
	<category: 'instance creation'>

	^ self
	    for: GTK.Gtk gtkFileChooserActionSave
	    title: aString
	    parent: aGtkWidget
	    button: GTK.Gtk gtkStockSave
    ]

    load: aString parent: aGtkWidget [
	<category: 'instance creation'>

	^ self
	    for: GTK.Gtk gtkFileChooserActionOpen
	    title: aString
	    parent: aGtkWidget
	    button: GTK.Gtk gtkStockOpen
    ]
]

GTK.GtkNotebook extend [

    pageNum: aGtkWidget [
	<category: 'C call-outs'>

	<cCall: 'gtk_notebook_page_num' returning: #int args: #( #self #cObject )>
    ]
]

GTK.GtkButton class extend [

    label: aString onPressedSend: aSymbol to: anObject [
	<category: 'instance creation'>

	^ (GTK.GtkButton newWithLabel: aString)
	    connectSignal: 'pressed' to: anObject selector: aSymbol userData: nil;
            yourself
    ]

]

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

GTK.GtkTextBuffer extend [

    text [
	<category: 'accessing'>

	^ self getText: self getStartIter end: self getEndIter includeHiddenChars: false
    ]
]

GTK.GtkTextBuffer extend [

    applyTagByName: aSymbol startOffset: aStartInteger endOffset: anEndInteger [
	<category: 'accessing'>

	| end start |
	start := GTK.GtkTextIter new.
        end := GTK.GtkTextIter new.
        self getIterAtOffset: start charOffset: aStartInteger.
        self getIterAtOffset: end charOffset: anEndInteger.
        self applyTagByName: aSymbol start: start end: end
    ]

    getIterAtOffset: offset [
	<category: 'accessing'>

	| result |
	result := GTK.GtkTextIter new.
	self getIterAtOffset: result charOffset: offset.
	^ result
    ]
]

GTK.GtkTreeView class extend [

    newWithTextColumn: aGtkModel title: aString [
        <category: 'user interface'>

        | view col render |
        view := self new
		    setModel: aGtkModel;
		    yourself.
        col := (GtkTreeViewColumn new)
		    packStart: (render := GTK.GtkCellRendererText new) expand: true;
		    addAttribute: render attribute: 'text' column: 0;
		    setTitle: aString;
		    yourself.
        view insertColumn: col position: -1.
	^ view
    ]

    newWithSortedTextColumn: aGtkModel title: aString [
	<category: 'instance creation'>

        | view col render |
        view := self new
                    setModel: aGtkModel;
                    yourself.
        col := (GtkTreeViewColumn new)
                packStart: (render := GtkCellRendererText new) expand: true;
                addAttribute: render attribute: 'text' column: 0;
                setTitle: aString;
                setSortIndicator: true;
                setSortColumnId: 0;
                setSortOrder: Gtk gtkSortAscending;
                yourself.
        view
            insertColumn: col position: -1.
	^ view
    ]
]

GTK.Gdk class extend [

    cairoCreate: aGdkWindow [
	<category: 'C call-outs'>

	<cCall: 'gdk_cairo_create' returning: #cObject args: #( #cObject )>
    ]
]

GTK.GValue class extend [
    
    new: aGType [
	<category: 'instance creation'>
	
	^ self new initializeType: aGType
    ]

    new: aGType value: anObject [
	<category: 'instance creation'>
	
	^ (self new: aGType)
	    value: anObject;
	    yourself
    ]

    value: anObject [
	<category: 'instance creation'>
	^ self new: anObject class asGType value: anObject
    ]
]

GTK.GValue extend [

    asBoolean [
        <category: 'converting'>
        <cCall: 'g_value_get_boolean' returning: #boolean args: #( #self )>
    ]

    asFloat [
        <category: 'converting'>
	<cCall: 'g_value_get_float' returning: #float args: #( #self )>
    ]

    asGBoxed [
        <category: 'converting'>
	<cCall: 'g_value_get_boxed' returning: #boolean args: #( #self )>
    ]

    asGObject [
        <category: 'converting'>
        <cCall: 'gstGtkInit' returning: #void args: #()>
    ]

    asGObjectInterface [
        <category: 'converting'>
        <cCall: 'gstGtkInit' returning: #void args: #()>
    ]

    asGParamSpec [
        <category: 'converting'>
        <cCall: 'gstGtkInit' returning: #void args: #()>
    ]

    asGPointer [
        <category: 'converting'>
        <cCall: 'gstGtkInit' returning: #void args: #()>
    ]

    asInteger [
        <category: 'converting'>
        <cCall: 'g_value_get_int' returning: #int args: #( #self )>
    ]

    asString [
        <category: 'converting'>
        <cCall: 'g_value_get_string' returning: #string args: #( #self )>
    ]

    value [
        <category: 'converting'>

	^ self type fundamentalType caseOf: {
	    [ GTK.GType boolean ] -> [ self asBoolean ].
	    [ GTK.GType string ] -> [ self asString ].
	    [ GTK.GType object ] -> [ self asGObject ].
	    [ GTK.GType boxed ] -> [ self asGBoxed ].
	    [ GTK.GType int ] -> [self asInteger ].
	    [ GTK.GType uint ] -> [ self asInteger ].
	    [ GTK.GType long ] -> [ self asInteger ].
	    [ GTK.GType ulong ] -> [ self asInteger ].
	    [ GTK.GType enum ] -> [ self asInteger ].
	    [ GTK.GType float ] -> [ self asFloat ].
	    [ GTK.GType param ] -> [ self asGParamSpec ].
	    [ GTK.GType pointer ] -> [ self asGPointer ].
	    [ GTK.GType interface ] -> [ self asGObjectInterface ]}
    ]

    value: anObject [
	<category: 'filling'>

	"anObject class asGType fundamentalType caseOf: {
	    [ GTK.GType string ] -> [self primGValue: handle setString: anObject].
	    [ GTK.GType boolean ] -> [self primGValue: handle setBoolean: anObject].
	    [ GTK.GType int ] -> [self primGValue: handle setInt: anObject].
	    [ GTK.GType float ] -> [self primGValue: handle setFloat: anObject asFloat].
	    [ GTK.GType param ] -> [self primGValueSetParam: handle param: anObject handle].
	    [ GTK.GType pointer ] -> [self primGValueSetPointer: handle vPointer: anObject handle].
	    [ GTK.GType object ] -> [self primGValue: handle setObject: anObject handle].
	    [ GTK.GType interface ] -> [self primGValueSetPointer: handle vPointer: anObject handle]}"
    ]

    initializeType: aGType [
	<category: 'initialize-release'>
	<cCall: 'g_value_init' returning: #{GTK.GValue} args: #( #self #cObject )>
    ]

    type [
	<category: 'type'>

	^ GType address: self address
    ]

    typeName [
        <category: 'type'>
	<cCall: 'g_type_name' returning: #string args: #( #self )>
    ]

]

