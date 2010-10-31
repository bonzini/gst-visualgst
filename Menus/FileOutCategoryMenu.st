MenuItem subclass: FileOutCategoryMenu [

    item [

	^ 'File out a category'
    ]

    command [

	^ FileOutCategoryCommand on: self browser
    ]
]

