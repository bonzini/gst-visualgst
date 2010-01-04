GtkConcreteWidget subclass: GtkFindWidget [

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

    buildPreviousButton [
	<category: 'user interface'>

        | image close |
        image := GTK.GtkImage newFromStock: GTK.Gtk gtkStockGoBack size: GTK.Gtk gtkIconSizeMenu.
        ^ (GTK.GtkButton new)
                setImage: image;
                setRelief: GTK.Gtk gtkReliefNone;
                connectSignal: 'pressed' to: self selector: #'closeIt:at:' userData: nil;
                yourself.
    ]

    buildNextButton [
        <category: 'user interface'>

        | image close |
        image := GTK.GtkImage newFromStock: GTK.Gtk gtkStockGoForward size: GTK.Gtk gtkIconSizeMenu.
        ^ (GTK.GtkButton new)
                setImage: image;
                setRelief: GTK.Gtk gtkReliefNone;
                connectSignal: 'pressed' to: self selector: #'closeIt:at:' userData: nil;
                yourself.
    ]

    buildWidget [
	<category: 'user interface'>

	^ (GTK.GtkHBox new: false spacing: 3)
	    packStart: self buildCloseButton expand: false fill: false padding: 0;
	    packStart: (GTK.GtkLabel new: 'find :') expand: false fill: false padding: 2;
	    packStart: GTK.GtkEntry new expand: false fill: false padding: 15;
	    packStart: self buildPreviousButton expand: false fill: false padding: 0; 
	    packStart: self buildNextButton expand: false fill: false padding: 0;
	    packStart: (GTK.GtkCheckButton newWithLabel: 'match case') expand: false fill: false padding: 0;
	    yourself
    ]

    close [
	self mainWidget hide
    ]
]

