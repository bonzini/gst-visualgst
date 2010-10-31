MenuItem subclass: FileOutMethodMenu [

    item [

	^ 'File out a method'
    ]

    command [

	^ FileOutMethodCommand on: self browser
    ]
]

