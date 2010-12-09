BrowserState subclass: NamespaceState [

    | classCategory |

    hash [
	<category: 'testing'>

        ^super hash bitXor: self classCategory fullname hash
    ]

    = aState [
	<category: 'testing'>

        ^self class = aState class
            and: [self classCategory fullname = aState classCategory fullname]
    ]

    printOn: aStream [
	<category: 'printing'>

	aStream
	    print: self namespace
    ]

    hasSelectedNamespace [
        <category: 'testing'>

        ^ true
    ]

    classCategory: aCategory [
	<category: 'accessing'>

	classCategory := aCategory
    ]

    classCategory [
	<category: 'accessing'>

	^ classCategory ifNil: [super classCategory ]
    ]

    namespace [
	<category: 'accessing'>

	^ state
    ]

    updateBrowser: aGtkClassBrowserWidget [
        <category: 'events'>
        aGtkClassBrowserWidget selectNamespaceState: self.
        aGtkClassBrowserWidget acceptNamespaceState: self
    ]

    selectInBrowser: aGtkClassBrowserWidget [
        self updateBrowser: aGtkClassBrowserWidget.
        aGtkClassBrowserWidget finishNamespaceState
    ]
]

