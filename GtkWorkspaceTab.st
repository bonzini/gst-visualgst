GtkEditTab subclass: GtkWorkspaceTab [
    | variableWidget variableTracker object |

    initialize [
	<category: 'intialization'>

	variableTracker := (WorkspaceVariableTracker new)
				initialize;
				yourself.
	object := variableTracker objectClass new.
	super initialize.
    ]

    postInitialize [
        <category: 'initialize'>

	super postInitialize.
        self updateState: BrowserState new
    ]

    buildMainWidget [
        <category: 'user interface'>

        ^ (GTK.GtkHPaned new)
		    add1: (self buildCodeView: GtkWorkspaceWidget);
		    add2: (variableWidget := GtkVariableTrackerWidget on: codeWidget variableTracker) mainWidget;
                    yourself
    ]

    targetObject [
	<category: 'evaluation'>

        ^ codeWidget targetObject
    ]

    doIt [
	<category: 'smalltalk event'>

	DoItCommand on: self
    ]

    debugIt [
	<category: 'smalltalk event'>

	DebugItCommand on: self
    ]

    inspectIt [
	<category: 'smalltalk event'>

	InspectItCommand on: self
    ]

    printIt [
	<category: 'smalltalk event'>

	PrintItCommand on: self
    ]

]
