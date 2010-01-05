Command subclass: OpenImplementorCommand [

    execute [
        <category: 'command'>

        | selection |
        (selection := VisualGST uniqueInstance onFocusPerform: #selectedText)
                ifNotNil: [ GtkImplementor openOn: (STInST.RBParser selectedSymbol: selection) ]
                ifNil: [ GtkImplementor open ].
    ]
]

