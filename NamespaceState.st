BrowserState subclass: NamespaceState [

    printOn: aStream [
	<category: 'printing'>

	aStream
	    print: self namespace
    ]

    hasSelectedNamespace [
        <category: 'testing'>

        ^ true
    ]

    namespace [
	<category: 'accessing'>

	^ state
    ]
]

