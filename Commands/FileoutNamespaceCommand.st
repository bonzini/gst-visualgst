NamespaceCommand subclass: FileoutNamespaceCommand [

    execute [
	<category: 'command'>

	self chooseDirectory
    ]

    chooseDirectory [
	| file |
        (GTK.GtkFileChooserDialog selectFolder: 'Save namespace as...' parent: nil)
            showModalOnAnswer: [ :dlg :res |
                res = GTK.Gtk gtkResponseAccept ifTrue: [ self fileoutNamespace: dlg getCurrentFolder ].
                dlg destroy ].
    ]

    fileoutNamespace: aDirectory [

        | namespace |
        namespace := target state namespace.
        self fileoutNamespace: namespace on: (File name: aDirectory) / namespace name
    ]

    fileoutNamespace: aNamespace on: aDirectory [
        <category: 'namespace events'>

        | stream |
        aDirectory exists ifFalse: [ aDirectory createDirectory ].
        stream := FileStream open: (aDirectory / 'self.st') asString mode: FileStream write.
        (NamespaceSource write: aNamespace on: stream)
                header.
        aNamespace do: [ :each |
            (each isNil not and: [ each isClass and: [ each environment = aNamespace ] ])
                    ifTrue: [ self fileoutClass: each from: aDirectory ] ]
    ]

    fileoutClass: aClass from: aDirectory [

	| directory stream |
	directory := self createCategories: aClass from: aDirectory.
	stream := FileStream open: (directory / ((aClass name asString) , '.st')) asString mode: FileStream write.
	(ClassSource write: aClass on: stream)
                source
    ]

    createCategories: aClass from: aDirectory [

        | categories directory |
	aClass category ifNil: [ ^ aDirectory ].
        categories := (aClass category tokenize: '-') asOrderedCollection.
        categories first = aClass environment name asString ifTrue: [ categories removeFirst ].
        directory := aDirectory.
        categories do: [ :each |
            directory := directory / each.
            directory exists ifFalse: [ directory createDirectory ] ].
	^ directory
    ]
]

