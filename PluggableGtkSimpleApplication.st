Smalltalk.Object subclass: PluggableGtkSimpleApplication [
    | container |

    <category: 'GtkLauncher'>
    <comment: nil>

    PluggableGtkSimpleApplication class >> buildWindow [
	<category: 'instance creation'>
	| w |
	w := GTK.GtkWindow new.
	w setTitle: self title.
	w setBorderWidth: 3.
	^w
    ]

    PluggableGtkSimpleApplication class >> open [
	<category: 'instance creation'>
	| w c |
	w := self buildWindow.
	c := self new.
	c container ifNotNil: [
	    w add: c container].
	self setupWindow: w on: c.
	w showAll.
	^{c. w}
    ]

    PluggableGtkSimpleApplication class >> setupWindow: aGtkWindow on: anInstance [
	"Called when a window has been created from #open"

	<category: 'instance creation'>
	anInstance setupWindow: aGtkWindow
    ]

    PluggableGtkSimpleApplication class >> title [
	<category: 'instance creation'>
	^'<unknown>'
    ]

    setupWindow: aGtkWindow [
	<category: 'initialize-release'>
	^nil
    ]

    container [
	<category: 'container'>
	^container ifNil: [container := self buildContainer]
    ]

    container: aGtkContainer [
	<category: 'container'>
	container := aGtkContainer
    ]

    buildContainer [
	<category: 'container'>
	^self subclassResponsibility
    ]
]
