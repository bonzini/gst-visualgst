GTK.GtkMenuItem class extend [

    menuItem: aString connectTo: anObject selector: aSymbol userData: userData [
	<category: 'instance creation'>

	^ (self newWithLabel: aString)
	    connectSignal: 'activate' to: anObject selector: aSymbol userData: userData;
	    yourself
    ]

    menuItem: aString connectTo: anObject selector: aSymbol [
        <category: 'instance creation'>

        ^ self menuItem: aString connectTo: anObject selector: aSymbol userData: nil 
    ]

    menuItem: aString accelPath: anAccelPathString [
	<category: 'instance creation'>

	^ (self newWithLabel: aString)
	    setAccelPath: anAccelPathString;
	    yourself
    ]

    menuItem: aString accelPath: anAccelPathString connectTo: anObject selector: aSymbol [
        <category: 'instance creation'>

        ^ (self menuItem: aString accelPath: anAccelPathString)
            connectSignal: 'activate' to: anObject selector: aSymbol userData: nil;
            yourself
    ]
]

