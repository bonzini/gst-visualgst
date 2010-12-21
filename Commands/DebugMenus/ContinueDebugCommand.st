DebugCommand subclass: ContinueCommand [

    item [
        <category: 'menu item'>

        ^ 'Continue'
    ]

    stockIcon [

        ^ 'Icons/go-run.png'
    ]

    execute [
        <category: 'command'>

        target run
    ]

]

