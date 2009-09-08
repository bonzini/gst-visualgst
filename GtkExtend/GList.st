GTK.GList extend [

    do: aOneArgBlock [
	<category: 'iterating'>

	| iter |
	iter := self.
	[ iter isNull not ] whileTrue: [
	    aOneArgBlock value: iter data value.
	    iter := iter next value ]
    ]
]
