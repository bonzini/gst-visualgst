MenuItem subclass: SenderMethodMenu [

    item [

	^ 'Browser senders'
    ]

    command [

	^ OpenSenderCommand on: self browser
    ]

    browserCommand [
        <category: 'accessing'>

	^ SenderMethodCommand on: self browser currentWidgetOfBrowser
    ]
]
