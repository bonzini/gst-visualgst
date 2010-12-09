Command subclass: OpenBottomPaneCommand [

    item [
        <category: 'menu item'>

        ^ 'Bottom Pane'
    ]

    accel [
        <category: 'accel'>

        ^ 'f4'
    ]

    execute [
        <category: 'command'>

        ^ GtkLauncher uniqueInstance showHideBottomPane
    ]
]
