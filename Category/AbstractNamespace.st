AbstractNamespace class extend [
    | icon |

    icon [
        <category: '*VisualGST'>

        ^ icon ifNil: [ icon := GTK.GdkPixbuf newFromFile: ((PackageLoader packageAt: 'VisualGST') / 'Icons/namespace.gif') file displayString error: nil ]
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
]

