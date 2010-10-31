MenuItem subclass: DeleteClassMenu [

    item [

	^ 'Delete a class'
    ]

    command [

	^ DeleteClassCommand on: self browser
    ]
]

