MenuItem subclass: InspectClassMenu [

    item [

	^ 'Inspect a class'
    ]

    command [

	^ InspectClassCommand on: self browser
    ]
]

