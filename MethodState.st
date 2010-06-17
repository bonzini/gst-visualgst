BrowserState subclass: MethodState [

    printOn: aStream [
	<category: 'printing'>

	aStream print: state value
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

        ^ state value methodCategory
    ]

    selectedCategory [
        <category: 'accessing'>

        ^ self category
    ]

    hasSelectedMethod [
        <category: 'testing'>

        ^ true
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

    classOrMetaSelected [
        <category: 'accessing'>

        ^ self classOrMeta
    ]
]

