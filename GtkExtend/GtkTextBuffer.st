GTK.GtkTextBuffer extend [

    text [
    <category: 'accessing'>

    ^ self getText: self getStartIter end: self getEndIter includeHiddenChars: false
    ]

    applyTagByName: aSymbol startOffset: aStartInteger endOffset: anEndInteger [
    <category: 'accessing'>

    | end start |
    start := GTK.GtkTextIter new.
        end := GTK.GtkTextIter new.
        self getIterAtOffset: start charOffset: aStartInteger.
        self getIterAtOffset: end charOffset: anEndInteger.
        self applyTagByName: aSymbol start: start end: end
    ]

    getIterAtOffset: offset [
    <category: 'accessing'>

    | result |
    result := GTK.GtkTextIter new.
    self getIterAtOffset: result charOffset: offset.
    ^ result
    ]

    iterOfSelectedText [
        <category: 'text accessing'>

        | iter |
        self getHasSelection
                ifTrue: [ iter := self getSelectionBounds ifNil: [ ^ self ].
                        (iter at: 1) getOffset > ((iter at: 2) getOffset)
                            ifTrue: [ iter swap: 1 with: 2 ] ]
                ifFalse: [ iter := {self getStartIter. self getEndIter} ].
        ^ iter
    ]

    selectedText [
        <category: 'text accessing'>

        | iter |
        iter := self iterOfSelectedText.
        ^ self getText: (iter at: 1) end: (iter at: 2) includeHiddenChars: false
    ]
]

