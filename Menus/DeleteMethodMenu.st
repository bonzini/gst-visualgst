MenuItem subclass: DeleteMethodMenu [

    item [

	^ 'Delete a method'
    ]

    command [

	^ DeleteMethodCommand on: self browser
    ]
]

