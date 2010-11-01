MenuItem subclass: InspectNamespaceMenu [

    item [

	^ 'Inspect a namespace'
    ]

    command [

	^ InspectNamespaceCommand on: self browser
    ]

    browserCommand [
        <category: 'accessing'>

	^ InspectNamespaceCommand on: self browser currentWidgetOfBrowser
    ]
]
