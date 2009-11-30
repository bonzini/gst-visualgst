GtkListWidget subclass: GtkMethodWidget [
    | column class category |
 
    GtkMethodWidget class >> on: aClass withCategory: aCategory [
	<category: 'instance creation'>
 
	^ (self new)
	    initialize;
	    class: aClass withCategory: aCategory;
	    yourself
    ]

    title [
	<category: 'accessing'>

	^ 'Methods'
    ]

    viewedItems [
        <category: 'accessing'>

        ^ #('text')
    ]
 
    methodModel [
	<category: 'accessing'>
 
	^ GtkMethodModel
    ]
 
    classOrMetaSelected [
        <category: 'accessing'>
 
        ^ self model classOrMeta
    ]
 
    category [
	<category: 'accessing'>
 
	^ self model category
    ]
 
    category: aString [
	<category: 'accessing'>
 
	self model category: aString.
    ]
 
    class: aClass withCategory: aString [
	<category: 'accessing'>
 
	self model classOrMeta: aClass withCategory: aString
    ]
 
    model [
	<category: 'accessing'>
 
 
	^ model ifNil: [ model := self methodModel new ]
    ]
 
    isTestMethod [
	<category: 'testing'>
 
	^ (self classOrMetaSelected inheritsFrom: TestCase) and: [ self selectedMethodSymbol startsWith: 'test' ]
    ]
 
    buildPopupMenu [
	<category: 'popup menu'>
 
	| menu |
        menu := GTK.GtkMenu new.
	self isTestMethod ifTrue: [ menu appendMenuItems: {{'Run test'. self. #runTest}} ].
	^ menu appendMenuItems: {{'Browse senders'. self. #browseSenders}.
	    {'Browse implementors'. self. #browseImplementors}.
	    {}.
	    {'Rename method'. self. #renameMethod}.
	    {'Delete method'. self. #deleteMethod}.
	    {}.
	    {'Inspect method'. self. #inspectMethod}.
	    {}.
	    {'File out method'. self. #fileoutMethod}};
	    yourself
    ]
 
    selectedCategory [
	<category: 'accessing'>
 
	^ category = '*'
	    ifTrue: [ nil ]
	    ifFalse: [ category ]
    ]
 
    selection [
	<category: 'accessing'>
 
	^ super selection first asSymbol
"=======

        | iter string |
        (iter := methodTree selectedIter) ifNil: [ ^nil ].
        ^ (self model gtkModel getOop: iter column: 0) asSymbol
>>>>>>> c5bbd60da660972b1a855c8459e450fc1165960a:GtkMethodWidget.st"
    ]
 
    selectedMethod [
	<category: 'accessing'>
<<<<<<< HEAD:GtkMethodWidget.st
 
	self hasSelection ifFalse: [ self error: 'Nothing is selected' ].
	^ self classOrMetaSelected compiledMethodAt: self selection
=======
"
	| symbol |
	(symbol := self selectedMethodSymbol) ifNil: [ ^nil ].
	^ self classOrMetaSelected compiledMethodAt: symbol
>>>>>>> c5bbd60da660972b1a855c8459e450fc1165960a:GtkMethodWidget.st"
    ]
 
    sourceCode [
	<category: 'accessing'>
 
	self hasSelection ifFalse: [ self error: 'Nothing is selected' ].
	^ (self classOrMetaSelected compiledMethodAt: self selection) methodRecompilationSourceString
    ]
 
    deleteMethod [
        <category: 'method events'>
 
        DeleteMethodCommand on: self
    ]
 
    inspectMethod [
        <category: 'method events'>
 
	InspectMethodCommand on: self
    ]
 
    browseSenders [
        <category: 'method events'>
 
	OpenSenderCommand on: self
    ]
 
    browseImplementors [
        <category: 'method events'>
 
	OpenImplementorCommand on: self
    ]
 
    runTest [
        <category: 'method events'>
 
	RunTestCommand on: self
    ]
 
    fileoutMethod [
        <category: 'method events'>
 
	FileoutMethodCommand on: self selectedMethod
    ]
]

