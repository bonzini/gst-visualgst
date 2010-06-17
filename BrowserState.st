Object subclass: BrowserState [
    | state |

    BrowserState class >> on: aBrowser with: aState [
	<category: 'instance creation'>

	^ self new
	    state: aState
    ]

    BrowserState class >> with: aState [
	<category: 'instance creation'>

	^ self new
	    state: aState
    ]

    state: aState [
	<category: 'initialize-release'>

	state := aState
    ]

    displayString [
        <category: 'printing'>

        ^ state displayString
    ]

    hasSelectedMethod [
        <category: 'testing'>

        ^ false
    ]

    hasSelectedCategory [
        <category: 'testing'>

        ^ false
    ]

    hasSelectedNamespace [
        <category: 'testing'>

        ^ false
    ]

    hasSelectedClass [
        <category: 'testing'>

        ^ false
    ]
]

