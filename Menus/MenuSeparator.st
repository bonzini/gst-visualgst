Object subclass: MenuSeparator [

    MenuSeparator class >> on: aGtkBuilder [
        <category: 'instance creation'>

        ^ self new
    ]

    MenuSeparator class >> buildOn: aGtkBuilder [
	<category: 'instance creation'>

	^ self new
		build
    ]

    MenuSeparator class >> browserBuildOn: aGtkBuilder [
	<category: 'instance creation'>

	^ self buildOn: aGtkBuilder
    ]

    build [
	<category: 'build'>

	^ GTK.GtkMenuItem new
    ]
]

