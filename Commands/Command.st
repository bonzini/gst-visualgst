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
	    target: aGtkBrowser;
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
			    accelBuild;
                            browserBuild
    ]

    | target |
    
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

    item [
        <category: 'accessing'>

	self subclassResponisibility 
    ]

    browserCommand [
        <category: 'accessing'>

	self subclassResponisibility 
    ]

    command [
        <category: 'accessing'>

	self subclassResponisibility 
    ]

    accel [
        <category: 'accessing'>

	^ ''
    ]

    build [
        <category: 'build'>

        ^ (GTK.GtkMenuItem newWithLabel: self item)
                connectSignal: 'activate' to: self selector: #command;
                yourself
    ]

    browserBuild [
        <category: 'build'>

        ^ GTK.GtkMenuItem menuItem: self item accelPath: self accelPath connectTo: self selector: #validAndExecute
    ]

    accelBuild [
        <category: 'build'>

	target accelGroup class
		    acceleratorGroup: target accelGroup 
		    accelerator: self accel 
		    path: self accelPath
    ]

    accelPath [
        <category: 'build'>

	^ target accelPath, '/', self class name
    ]
]

