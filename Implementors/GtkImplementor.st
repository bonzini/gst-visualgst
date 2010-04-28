GtkBrowserWrapper subclass: GtkImplementor [

    aboutImplementor [
        <category: 'events'>

        (GTK.GtkAboutDialog new)
            setVersion: VisualGST version;
            setLicense: VisualGST license;
            setWebsite: VisualGST website;
            setComments: 'This is a GTK+ wrapper for GNU Smalltalk.';
            setProgramName: 'GNU Smalltalk Implementor';
            showModalDestroy
    ]

    resultSelected [
	<category: 'events'>

	| selectedIter selectedString |
	(selectedIter := resultTree selectedIter) ifNil: [ ^ self ].
	selectedString := (self resultModel getOop: selectedIter column: 0).

	(resultArray at: selectedString) updateBrowser: classBrowserWidget.
    ]
]

