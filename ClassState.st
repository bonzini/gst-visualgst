BrowserState subclass: ClassState [

    printOn: aStream [
	<category: 'printing'>

	aStream
	    print: self classOrMeta
    ]

    hasSelectedCategory [
        <category: 'testing'>

        ^ false
    ]

    hasSelectedNamespace [
        <category: 'testing'>

        ^ true
    ]

    hasSelectedClass [
        <category: 'testing'>

        ^ true
    ]

    namespace [
	<category: 'accessing'>

	^ state environment
    ]

    classOrMeta [
	<category: 'accessing'>

	^ state
    ]
]

