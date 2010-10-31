MenuItem subclass: InspectNamespaceMenu [

    item [

	^ 'Inspect a namespace'
    ]

    command [

	^ InspectNamespaceCommand on: self browser
    ]
]

