MenuItem subclass: AddNamespaceMenu [

    item [

	^ 'Add a namespace'
    ]

    command [

	^ AddNamespaceCommand on: self browser
    ]
]

