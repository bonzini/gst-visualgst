GTK.GtkDialog extend [
    | codeblock destroy |

    runNonBlocking [
    <category: 'services'>

    destroy := false.
    self
        setModal: true;
        connectSignal: 'response' to: self selector: #onDialog:response: userData: nil;
        run 
    ]

    runNonBlockingAndDo: aCodeblock [
    <category: 'services'>

    destroy := false.
    codeblock :=  aCodeblock.
    self runNonBlocking
    ]
    
    runNonBlockingAndDestroy [
    <category: 'services'>

    destroy := true.
    self runNonBlocking
    ]

    runBlocking [
    <category: 'services'>

    destroy := false.
    self
        setModal: false;
        connectSignal: 'response' to: self selector: #onDialog:response: userData: nil;
            run
    ]

    runBlockingAndDo: aCodeblock [
    <category: 'services'>

    destroy := false.
    codeblock := aCodeblock.
    self runBlocking
    ]

    runBlockingAndDestroy [
        <category: 'services'>

        destroy := true.
        self
            setModal: false;
            connectSignal: 'response' to: self selector: #onDialog:response: userData: nil;
            run
    ]

    onDialog: aGtkDialog response: anInteger [
    <category: 'events'>

    destroy ifTrue: [ self destroy ].
    codeblock isNil ifFalse: [ codeblock value: aGtkDialog value: anInteger ]
    ]
]

