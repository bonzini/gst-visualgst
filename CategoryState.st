BrowserState subclass: CategoryState [

    printOn: aStream [
	<category: 'printing'>

	aStream
	    print: self classOrMeta;
	    nextPutAll: ' (';
	    display: self category;
	    nextPut: $)
    ]

    namespace [
	<category: 'accessing'>

	^ state key environment
    ]

    classOrMeta [
	<category: 'accessing'>

	^ state key
    ]

    category [
	<category: 'accessing'>

	^ state value
    ]

    selectedCategory [
	<category: 'accessing'>

	^ self category
    ]

    hasSelectedCategory [
        <category: 'testing'>

        ^ true
    ]

    hasSelectedNamespace [
        <category: 'testing'>

        ^ true
    ]

    hasSelectedClass [
        <category: 'testing'>

        ^ true
    ]

    displayString [
	<category: 'printing'>

	^ self classOrMeta displayString
    ]

    updateBrowser: aGtkClassBrowserWidget [
        <category: 'events'>
        self classState updateBrowser: aGtkClassBrowserWidget.
        aGtkClassBrowserWidget selectCategoryState: self.
        aGtkClassBrowserWidget acceptCategoryState: self
    ]

    selectInBrowser: aGtkClassBrowserWidget [
        self updateBrowser: aGtkClassBrowserWidget.
        aGtkClassBrowserWidget finishCategoryState
    ]
]
