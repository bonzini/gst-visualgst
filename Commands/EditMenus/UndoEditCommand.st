Command subclass: UndoEditCommand [

    item [
	<category: 'menu item'>

	^ 'Undo'
    ]

    accel [
        <category: 'accel'>

        ^ '<Control>Z'
    ]

    execute [
        <category: 'command'>

        self browser open
    ]
]
