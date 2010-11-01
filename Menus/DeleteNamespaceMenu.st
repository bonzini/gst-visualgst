MenuItem subclass: DeleteNamespaceMenu [

    item [

	^ 'Delete a namespace'
    ]

    command [

	^ DeleteNamespaceCommand on: self browser
    ]

    browserCommand [
        <category: 'accessing'>

	^ DeleteNamespaceCommand on: self browser currentWidgetOfBrowser
    ]
]
