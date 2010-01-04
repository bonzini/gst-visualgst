GtkTextPluginWidget subclass: GtkFindWidget [

    buildPreviousButton [
	<category: 'user interface'>

        ^ GTK.GtkButton previousButton
                connectSignal: 'pressed' to: self selector: #'closeIt:at:' userData: nil;
                yourself.
    ]

    buildNextButton [
        <category: 'user interface'>

        ^ GTK.GtkButton nextButton
                connectSignal: 'pressed' to: self selector: #'closeIt:at:' userData: nil;
                yourself.
    ]

    hBox [
	<category: 'user interface'>

	^ super hBox
	    packStart: (GTK.GtkLabel new: 'find :') expand: false fill: false padding: 2;
	    packStart: GTK.GtkEntry new expand: false fill: false padding: 15;
	    packStart: self buildPreviousButton expand: false fill: false padding: 0; 
	    packStart: self buildNextButton expand: false fill: false padding: 0;
	    packStart: (GTK.GtkCheckButton newWithLabel: 'match case') expand: false fill: false padding: 0;
	    yourself
    ]
]

