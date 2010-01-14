AbstractNamespace class extend [
    | icon |

    icon [
        <category: '*VisualGST'>

        ^ icon ifNil: [ icon := GTK.GdkPixbuf newFromFile: ((PackageLoader packageAt: 'VisualGST') / 'Icons/namespace.png') file displayString error: nil ]
    ]
]

AbstractNamespace extend [
    | categories |

    categories [
	<category: 'accessing'>

	^ categories ifNil: [ categories := VisualGST.ClassCategory for: self ]
    ]

    icon [
        <category: '*VisualGST'>

        ^ self class icon
    ]
]

