Command subclass: DeleteClassCommand [

    execute [
	<category: 'command'>

	target hasSelectedClass ifFalse: [ ^ self ].
        (DeleteClassUndoCommand delete: target selectedClass) push
    ]
]
