MenuItem subclass: DeleteNamespaceMenu [

    item [

	^ 'Delete a namespace'
    ]

    command [

	^ DeleteNamespaceCommand on: self browser
    ]
]

