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
    
	| ctxt |
	self context ifNil: [ ^ model := self emptyModel ].

	self model clear.
    
	ctxt := self context.
	[ ctxt isNil ] whileFalse: [
	    self append: ctxt method asString.
	    ctxt := ctxt parentContext ].
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
        self model append: iter.
        self model setOop: iter column: 0 value: aString
    ]
]

