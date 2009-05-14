Smalltalk.Object subclass: PluggableGtkView [
    | controller container components |
        
    <category: 'GtkLauncher'>
    <comment: nil>
    
    PluggableGtkView class >> open [
	<category: 'instance creation'>
	| view |
	view := self new.
	view open.
	^view
    ]

    PluggableGtkView class >> controller: aPluggableGtkController [
	<category: 'instance creation'>
	^self new controller: aPluggableGtkController; yourself
    ]

    setupController [
	<category: 'initialize-release'>
	^nil
    ]

    setupWindow: aGtkWindow [
	<category: 'initialize-release'>
	^nil
    ]

    componentAt: aSymbol [
	<category: 'components'>
	^self componentsAt: aSymbol
    ]
    
    componentAt: aSymbol in: aBlock [
	<category: 'components'>
	aBlock value: (self componentAt: aSymbol)
    ]
    
    componentAt: aSymbol put: anObject [
	<category: 'components'>
	self components at: aSymbol put: [anObject]
    ]

    components [
	<category: 'components'>
	^components ifNil: [components := Dictionary new]
    ]

    buildContainer [
	<category: 'container'>
	^self subclassResponsibility
    ]

    container [
	<category: 'container'>
	^container ifNil: [container := self buildContainer]
    ]

    container: anObject [
	<category: 'container'>
	container := anObject
    ]

    controller [
	<category: 'controller'>
	^controller ifNil: [controller := self buildDefaultController]
    ]

    controller: anObject [
	<category: 'controller'>
	controller := anObject
    ]
    
    buildDefaultController [
	<category: 'controller'>
	^self defaultController view: self
    ]

    defaultController [
	<category: 'controller'>
	^PluggableGtkController
    ]
    
    open [
	<category: 'viewing'>
	| w |
	w := GTK.GtkWindow new.
	w
	    title: self defaultWindowTitle;
	    setBorderWidth: 3;
	    add: self container.
	    self setupWindow: w.
	    self setupController.
	    w showAll.
	GTK.Gtk main
    ]

    defaultWindowTitle [
	^'<unknwon>'
    ]
]
