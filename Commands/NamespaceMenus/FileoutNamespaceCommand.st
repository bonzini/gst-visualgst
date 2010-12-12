NamespaceCommand subclass: FileoutNamespaceCommand [

    | namespace |

    item [

	^ 'File out a namespace'
    ]

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

        namespace := target state namespace.
        self 
	    fileoutNamespaceOn: (File name: aDirectory) / namespace name;
	    fileoutNamespaceExtendsOn: (File name: aDirectory) / namespace name
    ]

    fileoutNamespaceOn: aDirectory [
        <category: 'namespace events'>

        | stream |
        aDirectory exists ifFalse: [ aDirectory createDirectory ].
        stream := FileStream open: (aDirectory / 'self.st') asString mode: FileStream write.
        NamespaceHeaderSource write: namespace on: stream.
        namespace do: [ :each |
            (each isNil not and: [ each isClass and: [ each environment = namespace ] ])
                    ifTrue: [ self fileoutClass: each from: aDirectory ] ]
    ]

    fileoutNamespaceExtendsOn: aDirectory [
        <category: 'namespace events'>

        | stream |
        aDirectory exists ifFalse: [ aDirectory createDirectory ].
	self fileoutExtensionsTo: aDirectory
    ]

    fileoutClass: aClass from: aDirectory [

	| directory stream |
	directory := self createCategories: aClass category from: aDirectory.
	stream := FileStream open: (directory / ((aClass name asString) , '.st')) asString mode: FileStream write.
	ClassSource write: aClass on: stream
    ]

    fileoutBehaviorExtensions: aString with: anOrderedCollection into: aStream [

    ]

    checkFileoutExtensions [

        | extName dic |
        dic := Dictionary new.
        extName := '*', namespace name.
        CompiledMethod allInstancesDo: [ :each |
            (each methodCategory startsWith: extName) ifTrue: [
                (dic at: each methodClass ifAbsentPut: [ OrderedCollection new ]) add: each ] ].
        ^ dic
    ]

    fileoutExtensionsTo: aDirectory [

        | dic written |
        written := Set new.
        dic := self checkFileoutExtensions.
        dic keysDo: [ :aBehavior |
            (written includes: aBehavior asClass) ifFalse: [
                | stream |
                stream := (aDirectory / aBehavior asClass name, '-ext.st') writeStream.
                written add: aBehavior asClass.
                dic at: aBehavior asClass ifPresent: [ :anOrderedCollection | MethodSource writeMethods: anOrderedCollection on: stream ].
		stream setToEnd.
                dic at: aBehavior asMetaclass ifPresent: [ :anOrderedCollection | MethodSource writeMethods: anOrderedCollection on: stream ].
		stream close ] ]
    ]

    createCategories: aString from: aDirectory [

        | categories directory |
	(aString isNil or: [ aString isEmpty ]) ifTrue: [ ^ aDirectory ].
        categories := (aString tokenize: '-') asOrderedCollection.
        categories first = namespace name asString ifTrue: [ categories removeFirst ].
        directory := aDirectory.
        categories do: [ :each |
            directory := directory / each.
            directory exists ifFalse: [ directory createDirectory ] ].
	^ directory
    ]
]

