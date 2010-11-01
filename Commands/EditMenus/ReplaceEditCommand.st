Command subclass: ReplaceEditCommand [

    item [
	<category: 'menu item'>

	^ 'Replace'
    ]

    accel [
        <category: 'accel'>

        ^ '<Control>R'
    ]

    execute [
        <category: 'command'>

        self browser open
    ]
]
