MenuItem subclass: AddClassMenu [

    item [

	^ 'Add a class'
    ]

    command [

	^ AddClassCommand on: self browser
    ]

    browserCommand [
        <category: 'accessing'>

	^ AddClassCommand on: self browser currentWidgetOfBrowser
    ]
]
