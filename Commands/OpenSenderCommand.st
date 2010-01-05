Command subclass: OpenSenderCommand [

    execute [
        <category: 'command'>

        | selection |
        (selection := VisualGST uniqueInstance onFocusPerform: #selectedText)
                ifNotNil: [ GtkSender openOn: (STInST.RBParser selectedSymbol: selection) ]
                ifNil: [ GtkSender open ].
    ]
]

