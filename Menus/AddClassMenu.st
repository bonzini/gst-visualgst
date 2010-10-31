MenuItem subclass: AddClassMenu [

    item [

	^ 'Add a class'
    ]

    command [

	^ AddClassCommand on: self browser
    ]
]

