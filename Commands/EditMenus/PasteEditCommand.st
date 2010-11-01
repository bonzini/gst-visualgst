Command subclass: PasteEditCommand [

    item [
	<category: 'menu item'>

	^ 'Paste'
    ]

    accel [
        <category: 'accel'>

        ^ '<Control>V'
    ]

    execute [
        <category: 'command'>

        self browser open
    ]
]
