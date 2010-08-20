GtkImageResultsWidget subclass: GtkSenderResultsWidget [

    buildTreeView [
        <category: 'user interface'>

	| widget |
	widget := super buildTreeView.
	model contentsBlock: [ :each | {each displayString} ].
	^ widget
    ]

    appendSenderResults: aDictionary [

	self
	    clear;
	    findInMethod: aDictionary values first element
    ]

    literalsAndSpecialSelectors [
        <category: 'accessing'>

        ^  GtkSender literalsAndSpecialSelectors
    ]

    findInMethod: anObject [
        <category: 'find'>

        (self literalsAndSpecialSelectors at: anObject displaySymbol ifAbsent: [ #() ] ) do: [ :each |
            model append: each ].
    ]

    selectedResult: aBrowser [

        | currentMethod |
	self hasSelectedResult ifFalse: [ ^ self ].
        currentMethod := self selectedResult.

        aBrowser
                selectANamespace: currentMethod methodClass environment;
                selectAClass: (currentMethod methodClass isClass ifTrue: [ currentMethod methodClass ] ifFalse: [ currentMethod methodClass instanceClass ]).
        currentMethod methodClass isClass
                ifTrue: [ aBrowser selectAnInstanceMethod: currentMethod selector ]
                ifFalse: [ aBrowser selectAClassMethod: currentMethod selector  ]
    ]
]

