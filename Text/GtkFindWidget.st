GtkTextPluginWidget subclass: GtkFindWidget [
    | entry matchCase next previous |

    buildEntry [
	<category: 'user interface'>

	^ entry := GTK.GtkEntry new
			connectSignal: 'activate' to: self selector: #keyPressed userData: nil;
			yourself
    ]

    buildPreviousButton [
	<category: 'user interface'>

        ^ previous := GTK.GtkButton previousButton
    ]

    buildNextButton [
        <category: 'user interface'>

        ^ next := GTK.GtkButton nextButton
    ]

    buildMatchCaseButton [
        <category: 'user interface'>

	^ matchCase := GTK.GtkCheckButton newWithLabel: 'match case'
    ]

    hBox [
	<category: 'user interface'>

	^ super hBox
	    packStart: (GTK.GtkLabel new: 'find :') expand: false fill: false padding: 2;
	    packStart: self buildEntry expand: false fill: false padding: 15;
	    packStart: self buildPreviousButton expand: false fill: false padding: 0; 
	    packStart: self buildNextButton expand: false fill: false padding: 0;
	    packStart: self buildMatchCaseButton expand: false fill: false padding: 0;
	    yourself
    ]

    grabFocus [
	<category: 'focus'>

	entry grabFocus
    ]

    keyPressed [
	<category: 'entry events'>

    ]
]

