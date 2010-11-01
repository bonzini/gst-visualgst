MenuItem subclass: FileOutCategoryMenu [

    item [

	^ 'File out a category'
    ]

    command [

	^ FileOutCategoryCommand on: self browser
    ]

    browserCommand [
        <category: 'accessing'>

	^ FileOutCategoryCommand on: self browser currentWidgetOfBrowser
    ]
]
