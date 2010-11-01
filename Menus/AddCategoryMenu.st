MenuItem subclass: AddCategoryMenu [

    item [

	^ 'Add a category'
    ]

    command [

	^ AddCategoryCommand on: self browser
    ]

    browserCommand [
        <category: 'accessing'>

	^ AddCategoryCommand on: self browser currentWidgetOfBrowser
    ]
]
