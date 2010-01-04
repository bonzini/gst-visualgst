GtkConcreteWidget subclass: GtkReplaceWidget [

    initialize [
	<category: 'initialize'>

	self mainWidget: self buildWidget
    ]

    buildCloseButton [
	<category: 'user interface'>

        | image close |
        image := GTK.GtkImage newFromStock: GTK.Gtk gtkStockClose size: GTK.Gtk gtkIconSizeMenu.
        ^ (GTK.GtkButton new)
                setImage: image;
                setRelief: GTK.Gtk gtkReliefNone;
                connectSignal: 'pressed' to: self selector: #'close' userData: nil;
                yourself.
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

    close [
	self mainWidget hide.
    ]

    buildWidget [
	<category: 'user interface'>

	| hbox1 hbox2 vbox |
	(hbox1 := GTK.GtkHBox new: false spacing: 3)
	    packStart: (GTK.GtkButton newWithLabel: 'Replace all') expand: false fill: false padding: 0;
	    packStart: self buildReplaceButton expand: false fill: false padding: 0.
	    
	(hbox2 := GTK.GtkHBox new: false spacing: 3)
	    packStart: self buildCloseButton expand: false fill: false padding: 2;
	    packStart: (GTK.GtkLabel new: 'search for :') expand: false fill: false padding: 2;
	    packStart: GTK.GtkEntry new expand: false fill: false padding: 15;
	    packStart: (GTK.GtkLabel new: 'replace with :') expand: false fill: false padding: 2;
	    packStart: GTK.GtkEntry new expand: false fill: false padding: 15;
	    packStart: (GTK.GtkCheckButton newWithLabel: 'match case') expand: false fill: false padding: 0.

	^ (vbox := GTK.GtkVBox new: false spacing: 2)
	    packStart: hbox2 expand: false fill: false padding: 0;
	    packStart: hbox1 expand: false fill: false padding: 0;
	    yourself

    ]
]

