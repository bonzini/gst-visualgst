MenuItem subclass: FileOutNamespaceMenu [

    item [

	^ 'File out a namespace'
    ]

    command [

	^ FileOutNamespaceCommand on: self browser
    ]

    browserCommand [
        <category: 'accessing'>

	^ FileOutNamespaceCommand on: self browser currentWidgetOfBrowser
    ]
]
