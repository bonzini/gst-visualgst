MenuItem subclass: FileOutNamespaceMenu [

    item [

	^ 'File out a namespace'
    ]

    command [

	^ FileOutNamespaceCommand on: self browser
    ]
]

