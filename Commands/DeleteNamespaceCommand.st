Command subclass: DeleteNamespaceCommand [

    execute [
	<category: 'command'>

	| namespace |
        target hasSelectedNamespace ifFalse: [ ^ self ].
        namespace := target selectedNamespace.
        namespace subspaces isEmpty ifFalse: [ self error: 'Namespace has subspaces' ].
        (DeleteNamespaceUndoCommand delete: namespace) push
    ]
]

