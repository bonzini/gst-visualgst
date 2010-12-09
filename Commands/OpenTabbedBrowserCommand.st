OpenBrowserCommand subclass: OpenTabbedBrowserCommand [

    buildBrowserAndSelect: aState [
	<category: 'user interface'>

	| browser |
        browser := target launcher classBrowser.
        browser updateState: aState.
    ]

    execute [
        <category: 'command'>

	self buildBrowserAndSelect: self selection
    ]
]

