Object subclass: MenuBuilder [

    MenuBuilder class >> on: aGtkBrowser [
        <category: 'menu-building'>

        ^ self menus collect: [ :each | each on: aGtkBrowser ]
    ]

    MenuBuilder class >> on: aGtkBrowser appendTo: aGtkMenu [
        <category: 'menu-building'>

        ^ (self on: aGtkBrowser) do: [ :each | aGtkMenu append: each build ]
    ]

    MenuBuilder class >> browserBuildOn: aGtkBrowser [
	<category: 'menu-building'>

	^ self menus collect: [ :each | each browserBuildOn: aGtkBrowser ]
    ]

    MenuBuilder class >> buildOn: aGtkBrowser [
        <category: 'menu-building'>

        ^ self menus collect: [ :each | each buildOn: aGtkBrowser ]
    ]
]

