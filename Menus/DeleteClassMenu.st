MenuItem subclass: DeleteClassMenu [

    item [

	^ 'Delete a class'
    ]

    command [

	^ DeleteClassCommand on: self browser
    ]

    browserCommand [
        <category: 'accessing'>

	^ DeleteClassCommand on: self browser currentWidgetOfBrowser
    ]
]
