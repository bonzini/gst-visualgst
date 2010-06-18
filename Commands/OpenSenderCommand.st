Command subclass: OpenSenderCommand [

    selection [
        <category: 'focus checking'>

        target isNil ifTrue: [^nil].

        ((target browserHasFocus not or: [ target sourceCodeWidgetHasFocus ])
            and: [target hasSelection])
                ifTrue: [^STInST.RBParser selectedSymbol: target selectedText].

        ^target state hasSelectedMethod
                ifTrue: [ target state selector ]
                ifFalse: [ nil ]
    ]

    execute [
        <category: 'command'>

        | selection |
        selection := self selection.
        selection isNil ifTrue: [^GtkSender open].
	GtkSender openOn: selection
    ]
]

