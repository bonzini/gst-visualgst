MenuItem subclass: FileOutMethodMenu [

    item [

	^ 'File out a method'
    ]

    command [

	^ FileOutMethodCommand on: self browser
    ]

    browserCommand [
        <category: 'accessing'>

	^ FileOutMethodCommand on: self browser currentWidgetOfBrowser
    ]
]
