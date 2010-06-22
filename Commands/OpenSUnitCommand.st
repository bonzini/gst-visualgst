OpenBrowserCommand subclass: OpenSUnitCommand [

    defaltDestination [
        <category: 'selection'>

	^Smalltalk->TestCase
    ]

    selection [
        <category: 'selection'>

        | selection |
	selection := super selection printNl.
        selection value isNil ifTrue: [^selection].
        (selection value inheritsFrom: TestCase) ifTrue: [^selection].
        selection key == Smalltalk ifTrue: [^Smalltalk->TestCase].
        ^selection key->nil
    ]

    execute [
        <category: 'command'>

	| browser selection |
	browser := GtkSUnit open.
	selection := self selection.
	browser selectANamespace: selection key.
	selection value ifNotNil: [ browser selectAClass: selection value ]
    ]
]

