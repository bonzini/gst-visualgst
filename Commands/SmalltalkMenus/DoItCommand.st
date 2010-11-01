Command subclass: DoItCommand [

    item [
	<category: 'menu item'>

	^ 'Do It'
    ]

    accel [

	^ '<Control>D'
    ]

    execute [
        <category: 'command'>

        target doIt: target targetObject

    ]
]

