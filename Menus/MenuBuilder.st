Object subclass: MenuBuilder [

    MenuBuilder class >> on: aGtkBrowser [
        <category: 'menu-building'>

        ^ self menus collect: [ :each | each on: aGtkBrowser ]
    ]

    MenuBuilder class >> buildOn: aGtkBrowser [
	<category: 'menu-building'>

	^ self menus collect: [ :each | each buildOn: aGtkBrowser ]
    ]
]

