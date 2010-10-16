GtkShell subclass: GtkLauncher [
    GtkLauncher class [ | uniqueInstance | ]

    | imageName transcriptWidget systemChangeNotifier |

    GtkLauncher class >> uniqueInstance [
	<category: 'public'>

	uniqueInstance ifNil: [ self createInstance ].
        ^ uniqueInstance
    ]

    GtkLauncher class >> / path [
        <category: 'files'>

        ^ (PackageLoader packageAt: 'VisualGST') / path
    ]

    GtkLauncher class >> uniqueInstance: anObject [
        <category: 'private'>

	(uniqueInstance notNil and: [ anObject notNil ])
	    ifTrue: [ self error: 'cannot override uniqueInstance' ].
        uniqueInstance := anObject
    ]

    GtkLauncher class >> createInstance [
        <category: 'private'>

        ^ self basicNew open
    ]

    GtkLauncher class >> instanceCreationErrorString [
        <category: 'private'>

        ^ 'This is a singleton implementation, so you are not allowed to create instances yourself. Use #uniqueInstance to access the instance.'
    ]

    GtkLauncher class >> new [
        <category: 'instance creation'>

        ^ self error: self instanceCreationErrorString
    ]
 
    GtkLauncher class >> open [
	<category: 'user interface'>

        self uniqueInstance
    ]

    GtkLauncher class >> displayError: title message: error [
        <category: 'error'>

        | dialog |
        dialog := GTK.GtkMessageDialog
                                new: nil
                                flags: GTK.Gtk gtkDialogDestroyWithParent
                                type: GTK.Gtk gtkMessageWarning
                                buttons: GTK.Gtk gtkButtonsNone
                                message: 'Error'
                                tip: error.

        dialog
            addButton: 'Ok' responseId: 1;
            showModalOnAnswer: [ :dlg :res | dlg destroy ].
    ]

    GtkLauncher class >> displayError: error [
        ^self displayError: 'Error' message: error
    ]

    onDelete: aGtkWidget event: aGdkEvent [
	<category: 'window events'>

	self quit.
	^ true 
    ]

    quit [
        <category: 'file events'>

        | dialog |
        dialog := GTK.GtkMessageDialog
                                new: window
                                flags: GTK.Gtk gtkDialogDestroyWithParent
                                type: GTK.Gtk gtkMessageWarning
                                buttons: GTK.Gtk gtkButtonsNone
                                message: 'Save the image before exiting?'
                                tip: 'The image hosts all the code changes that you made %<since the last save|since starting VisualGST>1.  Unless you exported these changes, not saving the image will lose them.' % {saved}.

        dialog
            addButton: 'Exit without saving' responseId: 0;
            addButton: 'Cancel' responseId: 2;
            addButton: 'Save image' responseId: 1;
            setDefaultResponse: 2;
            showModalOnAnswer: [ :dlg :res |
                res = 0 ifTrue: [ self exit ].
                res = 1 ifTrue: [ self saveImageAndQuit ].
                dlg destroy ].
    ]

    saveImageAndQuit [
        <category: 'file events'>

        "ObjectMemory>>#snapshot breaks hard links due to
         http://bugzilla.kernel.org/show_bug.cgi?id=9138, so we have to
         check the permission of the directory rather than the file."
        imageName asFile parent isWriteable ifFalse: [ self saveImageAsAndQuit ].
        self saveImage: [ ObjectMemory snapshot: imageName. self exit ]
    ]

    saveImage [
        <category: 'file events'>

	"ObjectMemory>>#snapshot breaks hard links due to
	 http://bugzilla.kernel.org/show_bug.cgi?id=9138, so we have to
	 check the permission of the directory rather than the file."
	imageName asFile parent isWriteable ifFalse: [ ^ self saveImageAs ].
        self saveImage: [ ObjectMemory snapshot: imageName ]
    ]

    saveImageAs [
	<category: 'file events'>

	(GTK.GtkFileChooserDialog save: 'Save image as...' parent: window)
	    showModalOnAnswer: [ :dlg :res |
		imageName := dlg getFilename.
		dlg destroy.
		res = GTK.Gtk gtkResponseAccept ifTrue: [ self saveImage: [ ObjectMemory snapshot: imageName ] ] ]
    ]

    saveImageAsAndQuit [
        <category: 'file events'>

        (GTK.GtkFileChooserDialog save: 'Save image as...' parent: window)
            showModalOnAnswer: [ :dlg :res |
                imageName := dlg getFilename.
                dlg destroy.
                res = GTK.Gtk gtkResponseAccept ifTrue: [ self saveImage: [ ObjectMemory snapshot: imageName ]. self exit ] ]
    ]


    saveImage: aBlock [
	| oldMessage oldNotifier oldCatIcon oldNameIcon |
	oldNotifier := self systemChangeNotifier.
	oldMessage := Transcript message.

	oldCatIcon := ClassCategory icon.
	ClassCategory icon: nil.
	oldNameIcon := AbstractNamespace icon.
	AbstractNamespace icon: nil.

	Transcript message: stdout->#nextPutAllFlush:.
	SystemChangeNotifier root remove: oldNotifier.
	systemChangeNotifier := nil.
	self class uniqueInstance: nil.

	(saved := aBlock value not) ifTrue: [
            self class uniqueInstance: self.
	    ClassCategory icon: oldCatIcon.
	    AbstractNamespace icon: oldNameIcon.
	    systemChangeNotifier := oldNotifier.
	    SystemChangeNotifier root add: oldNotifier.
	    Transcript message: oldMessage ]
    ]

    systemChangeNotifier [
	<category: 'notifications'>

	^ systemChangeNotifier
    ]

    initialize [
	<category: 'initialization'>

        self class uniqueInstance: self.
        imageName := File image.
        systemChangeNotifier := SystemChangeNotifier new.
        SystemChangeNotifier root add: systemChangeNotifier.
        super initialize.
	window maximize.
    ]

    postInitialize [
	<category: 'initialization'>

	super postInitialize.
	transcriptWidget postInitialize.
    ]

    buildTranscriptWidget [
       <category: 'user interface'>

       ^(transcriptWidget := GtkTranscriptTab parentWindow: window)
            showAll;
            yourself
    ]

    buildInitialTabs [
       <category: 'user interface'>

	browsers addPermanentWidget: self buildTranscriptWidget labeled: 'Transcript'.
        super buildInitialTabs
    ]

    createEditMenus [
	<category: 'user interface'>

	^ super createEditMenus, {
            GTK.GtkMenuItem new.
            GTK.GtkMenuItem menuItem: 'Clear Transcript' connectTo: self selector: #clearTranscriptWidget}
    ]

    clearTranscriptWidget [
	<category: 'edit events'>

	transcriptWidget clear
    ]
]
