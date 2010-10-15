Object subclass: HistoryStack [

    | previousStack nextStack |

    HistoryStack class >> new [
        <category: 'instance creation'>
        ^super new initialize
    ]

    initialize [
	<category: 'initialization'>

	previousStack := OrderedCollection new.
	nextStack := OrderedCollection new.
    ]

    clear [
	<category: 'stack'>

        previousStack empty.
        nextStack empty.
    ]

    current [
	<category: 'stack'>
        ^previousStack isEmpty ifTrue: [ nil ] ifFalse: [ previousStack first ]
    ]

    push: aState [
	<category: 'stack'>

	aState isNil ifTrue: [^self].
        self current = aState ifTrue: [ ^self ].
        aState recordedState ifFalse: [ ^self ].
	nextStack empty.
	previousStack addFirst: aState
    ]

    size [
        <category: 'iteration'>

        ^nextStack size + previousStack size
    ]

    do: aBlock [
        <category: 'iteration'>

        nextStack reverseDo: aBlock.
        previousStack do: aBlock.
    ]

    selectedIndex [
	<category: 'undo-redo'>

        ^nextStack size + 1
    ]

    selectItem: anInteger [
	<category: 'undo-redo'>

        | n |
        (anInteger between: 1 and: self size)
            ifFalse: [self error: 'index out of range'].

        [ self selectedIndex < anInteger ] whileTrue: [
            nextStack addFirst: previousStack removeFirst ].
        [ self selectedIndex > anInteger ] whileTrue: [
            previousStack addFirst: nextStack removeFirst ].
    ]

    previous [
	<category: 'undo-redo'>

	previousStack size <= 1 ifTrue: [ ^ nil ].
	nextStack addFirst: previousStack removeFirst.
        ^self current
    ]

    next [
        <category: 'undo-redo'>

	nextStack isEmpty ifTrue: [ ^ nil ].
	previousStack addFirst: nextStack removeFirst.
        ^self current
    ]
]

