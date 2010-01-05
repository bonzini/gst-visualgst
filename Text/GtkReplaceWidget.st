GtkTextPluginWidget subclass: GtkReplaceWidget [


    hBox [
        <category: 'user interface'>

	^ super hBox
            packStart: (GTK.GtkLabel new: 'search for :') expand: false fill: false padding: 2;
            packStart: GTK.GtkEntry new expand: false fill: false padding: 15;
            packStart: (GTK.GtkLabel new: 'replace with :') expand: false fill: false padding: 2;
            packStart: GTK.GtkEntry new expand: false fill: false padding: 15;
            packStart: (GTK.GtkCheckButton newWithLabel: 'match case') expand: false fill: false padding: 0;
	    yourself
    ]

    buildReplaceButton [
        <category: 'user interface'>

        | image close |
        image := GTK.GtkImage newFromStock: GTK.Gtk gtkStockFindAndReplace size: GTK.Gtk gtkIconSizeMenu.
        ^ (GTK.GtkButton new)
                setImage: image;
                setRelief: GTK.Gtk gtkReliefNone;
                connectSignal: 'pressed' to: self selector: #'closeIt:at:' userData: nil;
                yourself.
    ]


    buildWidget [
	<category: 'user interface'>

	| hbox |
	(hbox := GTK.GtkHBox new: false spacing: 3)
	    packStart: (GTK.GtkButton newWithLabel: 'Replace all') expand: false fill: false padding: 0;
	    packStart: GTK.GtkButton replaceButton expand: false fill: false padding: 0.
	    

	^ super buildWidget
	    packStart: hbox expand: false fill: false padding: 0;
	    yourself

    ]
]

