Command subclass: PreviousTabCommand [

    item [
	<category: 'menu item'>

	^ 'Previous Tab'
    ]

    execute [
        <category: 'command'>

        self browser open
    ]
]
