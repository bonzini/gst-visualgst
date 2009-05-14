Smalltalk.Object subclass: PluggableGtkController [
    | view |
        
    <category: 'GtkLauncher'>
    <comment: nil>
    
    PluggableGtkController class >> run [
	<category: 'instance creation'>
	| c |
	c := self new.
	c run.
	^c
    ]

    PluggableGtkController class >> view: aPluggableGtkView [
	<category: 'instance creation'>
	^self new view: aPluggableGtkView; yourself
    ]

    run [
	<category: 'running'>
	self view open
    ]

    buildDefaultView [
	<category: 'view'>
	^self defaultView controller: self
    ]

    defaultView [
	<category: 'view'>
	^PluggableGtkView
    ]
    
    setupView [
	<category: 'view'>
	^nil
    ]
    
    view [
	<category: 'view'>
	^view ifNil: [view := self buildDefaultView]
    ]

    view: aPluggableGtkView [
	<category: 'view'>
	(aPluggableGtkView isKindOf: self defaultView)
	    ifFalse: [^self error: 'Invalid view'].
	view := aPluggableGtkView.
	self setupView
    ]

    componentAt: aSymbol [
	<category: 'view components'>
	^self view componentAt: aSymbol
    ]

    componentAt: aSymbol in: aView [
	<category: 'view components'>
	^self view componentAt: aSymbol in: aView
    ]
]
