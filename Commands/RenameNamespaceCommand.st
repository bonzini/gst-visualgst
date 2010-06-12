Command subclass: RenameNamespaceCommand [

    execute [
	<category: 'command'>

	| dlg |
	target hasSelectedNamespace ifFalse: [ ^ self ].
        dlg := GtkEntryDialog title: 'Rename a namespace' text: 'Name of the new namespace'.
        dlg hasPressedOk ifTrue: [ 
            (RenameNamespaceUndoCommand rename: target selectedNamespace as: dlg result asSymbol) push ]
    ]
]

