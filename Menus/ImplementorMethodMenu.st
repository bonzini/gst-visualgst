MenuItem subclass: ImplementorMethodMenu [

    item [

	^ 'Browser implementors'
    ]

    command [

	^ OpenImplementorCommand on: self browser
    ]

    browserCommand [
        <category: 'accessing'>

	^ OpenImplementorCommand on: self browser currentWidgetOfBrowser
    ]
]
