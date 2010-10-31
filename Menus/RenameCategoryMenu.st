MenuItem subclass: RenameCategoryMenu [

    item [

	^ 'Rename a category'
    ]

    command [

	^ RenameCategoryCommand on: self browser
    ]
]

