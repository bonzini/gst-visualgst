AbstractEvent subclass: ReorganizedEvent [

    printEventKindOn: aStream [
	<category: 'printing'>

	aStream nextPutAll: 'Reorganized'
    ]

    isReorganized [
	<category: 'testing'>

	^ true
    ]

    changeKind [
	<category: 'accessing'>

	^ #Reorganized
    ]

    supportedKinds [
	<category: 'accessing'>

	^ Array with: self classKind
    ]
]

