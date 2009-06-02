Cairo.CairoContext class extend [
    context: aCObject [
	<category: 'instance creation'>

	^ (self new)
	    context: aCObject;
	    depth: 0;
	    addToBeFinalized.
    ]
]

Cairo.CairoContext extend [
    context: aCObject [
	<category: 'accessing'>

	context := aCObject
    ]

    depth: anInteger [
	<category: 'accessing'>

	depth := anInteger
    ]
]

