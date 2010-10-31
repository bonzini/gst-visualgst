Object subclass: MenuSeparator [

    MenuSeparator class >> on: aGtkBuilder [
        <category: 'instance creation'>

        ^ self new
    ]

    MenuSeparator class >> buildOn: aGtkBuilder [
	<category: 'instance creation'>

	^ self new
		build;
		yourself
    ]

    build [
	<category: 'build'>

	^ GTK.GtkMenuItem new
    ]
]

