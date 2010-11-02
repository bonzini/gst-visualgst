Command subclass: HistoryBackCommand [

    item [
	<category: 'menu item'>

	^ 'Back'
    ]

    execute [
        <category: 'command'>

        self browser open
    ]
]
