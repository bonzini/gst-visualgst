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
]

