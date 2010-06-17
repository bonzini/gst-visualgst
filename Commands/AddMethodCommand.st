ClassCommand subclass: AddMethodCommand [

    execute [
	<category: 'command'>

        (AddMethodUndoCommand
	    add: target sourceCode
	    classified: target state category 
	    in: target state classOrMeta
	    browser: target) push
    ]
]

