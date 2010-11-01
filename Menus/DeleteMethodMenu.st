MenuItem subclass: DeleteMethodMenu [

    item [

	^ 'Delete a method'
    ]

    command [

	^ DeleteMethodCommand on: self browser
    ]

    browserCommand [
        <category: 'accessing'>

	^ DeleteMethodCommand on: self browser currentWidgetOfBrowser
    ]
]
