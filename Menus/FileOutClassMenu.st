MenuItem subclass: FileOutClassMenu [

    item [

	^ 'File out a class'
    ]

    command [

	^ FileOutClassCommand on: self browser
    ]
]

