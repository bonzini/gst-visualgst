Object subclass: Command [

    Command class >> execute [
	<category: 'instance creation'>

	^ self new
	    validAndExecute
    ]

    Command class >> target: anObject [
        <category: 'instance creation'>

	^ self new
	    target: anObject;
	    yourself
    ]

    Command class >> on: anObject [
	<category: 'instance creation'>
    
	^ (self target: anObject)
		    validAndExecute
    ]

    Command class >> on: aGtkBrowser [
        <category: 'instance creation'>

        ^ self new
            browser: aGtkBrowser;
            yourself
    ]

    Command class >> buildOn: aGtkBrowser [
        <category: 'instance creation'>

        ^ (self on: aGtkBrowser)
                            build
    ]

    Command class >> browserBuildOn: aGtkBrowser [
        <category: 'instance creation'>

        ^ (self on: aGtkBrowser)
                            browserBuild
    ]

    | browser target |
    
    target: anObject [
	<category: 'accessing'>

	target := anObject
    ]

    execute [
	<category: 'command'>

	self subclassResponisibility 
    ]

    valid [
	<category: 'command'>

	^ true
    ]

    validAndExecute [
	<category: 'command'>

        self valid ifFalse: [ ^ self ].
        ^ self
            execute;
            yourself
    ]

    browser: aGtkBrowser [
        <category: 'accessing'>

        browser := aGtkBrowser
    ]

    browser [
        <category: 'accessing'>

        ^ browser
    ]

    item [
        <category: 'accessing'>

    ]

    browserCommand [
        <category: 'accessing'>

    ]

    command [
        <category: 'accessing'>

    ]

    shortcut [
        <category: 'accessing'>

    ]

    build [
        <category: 'build'>

        ^ (GTK.GtkMenuItem newWithLabel: self item)
                connectSignal: 'activate' to: self selector: #command;
                yourself
    ]

    browserBuild [
        <category: 'build'>

        ^ (GTK.GtkMenuItem newWithLabel: self item)
                connectSignal: 'activate' to: self selector: #browserCommand;
                yourself
    ]
]

