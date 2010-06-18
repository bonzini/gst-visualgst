GtkObjectInspectorView subclass: GtkSetInspectorView [

    values [
	^ super values, self object asOrderedCollection
    ]

    selectedValue: anObject [
        <category: 'events'>

        ^ (self object includes: anObject)
            ifFalse: [ super selectedValue: anObject ]
            ifTrue: [ anObject ]
    ]
]

