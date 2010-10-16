OpenBrowserCommand subclass: OpenTabbedBrowserCommand [

    item [
	<category: 'user interface'>
        ^'New browser'
    ]

    buildBrowserAndSelect: aState [
	<category: 'user interface'>

	| browser |
        browser := target shell classBrowser.
        browser updateState: aState.
    ]
]

