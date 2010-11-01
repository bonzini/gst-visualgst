MenuItem subclass: FileOutClassMenu [

    item [

	^ 'File out a class'
    ]

    command [

	^ FileOutClassCommand on: self browser
    ]

    browserCommand [
        <category: 'accessing'>

	^ FileOutClassCommand on: self browser currentWidgetOfBrowser
    ]
]
