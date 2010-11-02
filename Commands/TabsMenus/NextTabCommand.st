Command subclass: NextTabCommand [

    item [
	<category: 'menu item'>

	^ 'Next Tab'
    ]

    execute [
        <category: 'command'>

        self browser open
    ]
]
