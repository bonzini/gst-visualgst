MenuItem subclass: AddNamespaceMenu [

    item [

	^ 'Add a namespace'
    ]

    command [

	^ AddNamespaceCommand on: self browser
    ]

    browserCommand [
        <category: 'accessing'>

	^ AddNamespaceCommand on: self browser currentWidgetOfBrowser
    ]
]
