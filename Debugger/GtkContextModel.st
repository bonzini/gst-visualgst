Object subclass: GtkContextModel [

    GtkContextModel class >> on: aContext [
	<category: 'instance creation'>

        ^ (self new)
	    context: aContext;
	    yourself
    ]

    | model context |

    context [
	<category: 'accessing'>

	^ context
    ]

    context: aContext [
	<category: 'accessing'>

	context := aContext.
	self refreshModel
    ]

    model [
	<category: 'accessing'>

	^ model ifNil: [
	    model := GTK.GtkListStore new: 1 varargs: {GTK.GValue gTypeString} ]
    ]

    emptyModel [
	<category: 'accessing'>

	^ GTK.GtkListStore new: 1 varargs: {GTK.GValue gTypeString}
    ]

    refreshModel [
	<category: 'events'>
    
	| ctxt stream |
	self context ifNil: [ ^ model := self emptyModel ].

	self model clear.
    
	ctxt := self context.
	[ ctxt isNil ] whileFalse: [
	    ctxt printDebugHeaderOn: (stream := WriteStream on: String new).
	    self append: stream contents.
	    ctxt := ctxt parentContext ].
    ]

    selectLastContext [
	<category: 'item selection'>

	^ self model lastIter
    ]

    findIterInAMethod: aString [
        <category: 'item selection'>

        | iter stack parent path pathString number |
        iter := GTK.GtkTreeIter new.
        path := GTK.GtkTreePath newFirst.
        [self model getIter: iter path: path] whileTrue: [
            self model getIter: iter path: path.
            (aString = (self model getOop: iter column: 0))
                ifTrue: [ ^ iter  ].
            path next ].
        self error: 'Context not found'
    ]

    append: aString [
	<category: 'model builder'>
    
	| iter |
        iter := GTK.GtkTreeIter new.
        self model prepend: iter.
        self model setOop: iter column: 0 value: aString
    ]
]

