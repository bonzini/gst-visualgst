MenuItem subclass: RenameClassMenu [

    item [

	^ 'Rename a class'
    ]

    command [

	^ RenameClassCommand on: self browser
    ]
]

