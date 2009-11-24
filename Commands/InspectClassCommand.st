Command subclass: InspectClassCommand [

    execute [
	<category: 'command'>

	target hasSelection ifFalse: [ ^ self ].
        GtkInspector openOn: target selectedClass
    ]
]
