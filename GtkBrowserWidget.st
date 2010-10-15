GtkConcreteWidget subclass: GtkBrowserWidget [
    | browser |

    browser [
        <category: 'initialization'>

        ^browser
    ]

    browser: aGtkClassBrowserWidget [
        <category: 'initialization'>

        browser := aGtkClassBrowserWidget
    ]

    onSelectionChanged [
        browser isNil ifFalse: [browser updateState: self state]
    ]

    connectToSignal: aString of: anObject [
        <category: 'events'>

        anObject
            connectSignal: 'changed' to: self selector: #onSelectionChanged
    ]

    state [
        <category: 'events'>

        self subclassResponsibility
    ]
]

