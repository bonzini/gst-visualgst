DoItCommand subclass: InspectItCommand [

    item [
        <category: 'menu item'>

        ^ 'Inspect It'
    ]

    accel [

	^ '<Control>I'
    ]

    execute [
        <category: 'command'>

        target inspectIt: target targetObject

    ]
]

