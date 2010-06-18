GtkObjectInspectorView subclass: GtkDictionaryInspectorView [

    values [
	^ super values, self object keys asOrderedCollection
    ]

    selectedValue: anObject [
        <category: 'events'>

        ^ (self object includesKey: anObject)
            ifFalse: [ super selectedValue: anObject ]
            ifTrue: [ self object at: anObject ]
    ]
]

