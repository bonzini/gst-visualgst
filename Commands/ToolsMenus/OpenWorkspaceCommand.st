Command subclass: OpenWorkspaceCommand [

    item [
        <category: 'menu item'>

        ^ 'Workspace'
    ]

    execute [
        <category: 'command'>

        ^ target shell newWorkspace
    ]
]
