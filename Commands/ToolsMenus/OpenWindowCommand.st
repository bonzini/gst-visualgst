Command subclass: OpenWindowCommand [

    item [
        <category: 'menu item'>

        ^ 'New window'
    ]

    execute [
        <category: 'command'>

        ^ GtkShell open
    ]
]
