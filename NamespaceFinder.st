AbstractFinder subclass: NamespaceFinder [
    | namespace |

    NamespaceFinder class >> on: aNamespace [
	<category: 'instance creation'>

	^ (self new)
	    namespace: aNamespace;
	    yourself
    ]

    namespace: aNamespace [
	<category: 'accessing'>

	namespace := aNamespace
    ]

    displayString [
	<category: 'printing'>

	^ namespace displayString
    ]

    updateBrowser: aGtkClassBrowserWidget [
	<category: 'events'>

	aGtkClassBrowserWidget selectANamespace: namespace
    ]
]

