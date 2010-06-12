Command subclass: DeleteMethodCommand [

    execute [
	<category: 'command'>

        target hasSelectedMethod ifFalse: [ ^ self ].
        (DeleteMethodUndoCommand delete: target selectedMethodSymbol in: target classOrMetaSelected) push
    ]
]

