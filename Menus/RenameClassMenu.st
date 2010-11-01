MenuItem subclass: RenameClassMenu [

    item [

	^ 'Rename a class'
    ]

    command [

	^ RenameClassCommand on: self browser
    ]

    browserCommand [
        <category: 'accessing'>

	^ RenameClassCommand on: self browser currentWidgetOfBrowser
    ]
]
