MenuItem subclass: SenderMethodMenu [

    item [

	^ 'Browser senders'
    ]

    command [

	^ OpenSenderCommand on: self browser
    ]
]

