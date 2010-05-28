AbstractNamespace class extend [
    Icon := nil.

    icon [
        <category: '*VisualGST'>

        ^ Icon ifNil: [ Icon := GTK.GdkPixbuf newFromFile: ((PackageLoader packageAt: 'VisualGST') / 'Icons/namespace.gif') file displayString error: nil ]
    ]

    icon: aGdkPixbuf [
        <category: '*VisualGST'>

        Icon := aGdkPixbuf
    ]
]

AbstractNamespace extend [
    | categories |

    namespace [
	<category: 'accessing'>

	^ self
    ]

    category [
	<category: 'accessing'>

	^ VisualGST.ClassCategory basicNew
    ]

    categories [
	<category: 'accessing'>

	^ categories ifNil: [ categories := VisualGST.ClassCategory for: self ]
    ]

    icon [
        <category: '*VisualGST'>

        ^ self class icon
    ]

    isCategory [
	<category: 'testing'>

	^ false
    ]
]

