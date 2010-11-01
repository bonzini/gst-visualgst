MenuItem subclass: RenameCategoryMenu [

    item [

	^ 'Rename a category'
    ]

    command [

	^ RenameCategoryCommand on: self browser
    ]

    browserCommand [
        <category: 'accessing'>

	^ RenameCategoryCommand on: self browser currentWidgetOfBrowser
    ]
]
