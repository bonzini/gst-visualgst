MenuItem subclass: InspectMethodMenu [

    item [

	^ 'Inspect a method'
    ]

    command [

	^ InspectMethodCommand on: self browser
    ]

    browserCommand [
        <category: 'accessing'>

	^ InspectMethodCommand on: self browser currentWidgetOfBrowser
    ]
]
