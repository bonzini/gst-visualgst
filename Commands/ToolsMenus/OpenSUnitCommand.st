OpenBrowserCommand subclass: OpenSUnitCommand [

    item [
        <category: 'menu item'>

        ^ 'SUnit'
    ]

    defaultDestination [
        <category: 'selection'>

	^super defaultDestination namespaceState
    ]

    selection [
        <category: 'selection'>

        | selection |
	selection := super selection.
        selection hasSelectedClass ifFalse: [^selection].
        (selection classOrMeta inheritsFrom: TestCase) ifTrue: [^selection].
        ^NamespaceState with: selection classOrMeta environment
    ]

    buildBrowserAndSelect: aState [
        <category: 'command'>

	| browser selection |
	browser := target shell sunitBrowser.
	browser updateState: aState
    ]
]

