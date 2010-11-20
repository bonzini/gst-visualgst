Command subclass: CloseTabCommand [

    item [
	<category: 'menu item'>

	^ 'Close Tab'
    ]

    execute [
        <category: 'command'>

        self browser open
    ]
]
