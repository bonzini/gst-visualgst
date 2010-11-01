MenuItem subclass: RenameNamespaceMenu [

    item [

	^ 'Rename a namespace'
    ]

    command [

	^ RenameNamespaceCommand on: self browser
    ]

    browserCommand [
        <category: 'accessing'>

	^ RenameNamespaceCommand on: self browser currentWidgetOfBrowser
    ]
]
