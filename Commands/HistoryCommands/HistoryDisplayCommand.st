Command subclass: HistoryDisplayCommand [

    item [
	<category: 'menu item'>

	^ 'Show/Hide history pane'
    ]

    execute [
        <category: 'command'>

        self browser open
    ]
]
