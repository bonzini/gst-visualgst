DoItCommand subclass: PrintItCommand [

    item [
        <category: 'menu item'>

        ^ 'Print It'
    ]

    accel [

	^ '<Control>P'
    ]

    execute [
        <category: 'command'>

        target printIt: target targetObject

    ]
]

