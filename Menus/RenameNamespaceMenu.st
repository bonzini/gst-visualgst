MenuItem subclass: RenameNamespaceMenu [

    item [

	^ 'Rename a namespace'
    ]

    command [

	^ RenameNamespaceCommand on: self browser
    ]
]

