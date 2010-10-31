Object subclass: Command [

    Command class >> execute [
	<category: 'instance creation'>

	^ self new
	    executeIfValid
    ]

    Command class >> executeOn: anObject [
	<category: 'instance creation'>
    
	^ (self on: anObject)
		    executeIfValid
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

    executeIfValid [
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

    accel [
        <category: 'accessing'>

	^ ''
    ]

    build [
        <category: 'build'>

        ^ (GTK.GtkMenuItem newWithLabel: self item)
                connectSignal: 'activate' to: self selector: #executeIfValid;
                yourself
    ]

    browserBuild [
        <category: 'build'>

        ^ GTK.GtkMenuItem menuItem: self item accelPath: self accelPath connectTo: self selector: #executeIfValid
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

