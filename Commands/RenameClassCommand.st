Command subclass: RenameClassCommand [

    execute [
	<category: 'command'>

	| dlg |
        target hasSelectedClass ifFalse: [ ^ self ].
        dlg := GtkEntryDialog title: 'Rename a class' text: 'Name of the class'.
        dlg hasPressedOk ifTrue: [
            (RenameClassUndoCommand rename: target selectedClass as: dlg result asSymbol) push ]
    ]
]

