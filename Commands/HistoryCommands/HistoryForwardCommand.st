Command subclass: HistoryForwardCommand [

    item [
	<category: 'menu item'>

	^ 'Forward'
    ]

    execute [
        <category: 'command'>

        self browser open
    ]
]
