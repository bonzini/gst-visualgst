DoItCommand subclass: DebugItCommand [

    item [
        <category: 'menu item'>

        ^ 'Debug It'
    ]

    accel [

	^ '<Alt>D'
    ]

    execute [
        <category: 'command'>

        target debugIt: target targetObject

    ]
]

