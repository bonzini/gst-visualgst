MenuItem subclass: InspectClassMenu [

    item [

	^ 'Inspect a class'
    ]

    command [

	^ InspectClassCommand on: self browser
    ]

    browserCommand [
        <category: 'accessing'>

	^ InspectClassCommand on: self browser currentWidgetOfBrowser
    ]
]
