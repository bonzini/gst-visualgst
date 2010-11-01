MenuItem subclass: ImplementorMethodMenu [

    item [

	^ 'Browser implementors'
    ]

    command [

	^ OpenImplementorCommand on: self browser
    ]
]

