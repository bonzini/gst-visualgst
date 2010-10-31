MenuItem subclass: AddCategoryMenu [

    item [

	^ 'Add a category'
    ]

    command [

	^ AddCategoryCommand on: self browser
    ]
]

