MenuItem subclass: InspectMethodMenu [

    item [

	^ 'Inspect a method'
    ]

    command [

	^ InspectMethodCommand on: self browser
    ]
]

