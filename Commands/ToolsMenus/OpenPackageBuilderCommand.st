Command subclass: OpenPackageBuilderCommand [

    item [
        <category: 'menu item'>

        ^ 'PackageBuilder'
    ]

    accel [
        <category: 'accel'>

        ^ '<Alt>P'
    ]

    execute [
        <category: 'command'>

        ^ target shell showHidePackageBuilder
    ]
]
