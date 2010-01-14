Object subclass: ClassCategory [
    | categories classes name namespace parent |

    <category: 'Language-Implementation'>

    ClassCategory class [ | uniqueInstance icon | ]

    ClassCategory class >> icon [
	<category: '*VisualGST'>
	
	^ icon ifNil: [ icon := GTK.GdkPixbuf newFromFile: ((PackageLoader packageAt: 'VisualGST') / 'Icons/category.gif') file displayString error: nil ]
    ]

    ClassCategory class >> named: aString [
	<category: 'instance creation'>

	^ self named: aString parent: nil 
    ]

    ClassCategory class >> named: aString parent: aClassCategory [
        <category: 'instance creation'>

        ^ self basicNew
                    name: aString;
		    parent: aClassCategory;
                    yourself
    ]

    ClassCategory class >> for: aNamespace [
	<category: 'instance creation'>

	| category classes |
	category := self basicNew.
        classes := aNamespace definedKeys.
        classes do: [ :each | (aNamespace at: each) isClass ifTrue: [ self extractCategory: (aNamespace at: each) for: category ] ].
	category childrenNamespace: aNamespace.
	^ category categories
    ]

    ClassCategory class >> uniqueInstance [
	<category: 'accessing'>

	^ uniqueInstance ifNil: [ uniqueInstance := self basicNew ]
    ]

    ClassCategory class >> initialize [
	<category: 'initialize'>

	self extractCategory: Class
    ]

    ClassCategory class >> extractCategory: aClass [
	<category: 'extraction'>

	self extractCategory: aClass for: self uniqueInstance.
	aClass subclassesDo: [ :each |
	    self extractCategory: each ]
    ]

    ClassCategory class >> extractCategory: aClass for: aParentCategory [
        <category: 'extraction'>

        | category subcat token |
        token := aClass category ifNil: [ #() ] ifNotNil: [ aClass category tokenize: '-' ].
        category := aParentCategory.
        token do: [ :each |
            category categories at: each ifAbsent: [ category categories at: each put: (self named: each parent: category) ].
            category := category categories at: each ].
        category classes add: aClass asClass
    ]

    namespace [
        <category: 'accessing'>

        ^ namespace
    ]

    namespace: aNamespace [
        <category: 'accessing'>

        namespace := aNamespace
    ]

    childrenNamespace: aNamespace [
        <category: 'accessing'>

	self namespace: aNamespace.
	self categories values do: [ :each | each childrenNamespace: aNamespace ]
    ]

    category [
        <category: 'accessing'>

        ^ self
    ]

    name: aString [
	<category: 'accessing'>

	name := aString
    ]

    name [
	<category: 'accessing'>

	^ name ifNil: [ name := String new ]
    ]

    parent: aCategory [
	<category: 'accessing'>

	parent := aCategory
    ]

    parent [
	<category: 'accessing'>

	^ parent
    ]

    category [
	<category: 'accessing'>

	^ self
    ]

    categories [
	<category: 'accessing'>

	^ categories ifNil: [ categories := Dictionary new ]
    ]
    
    subspaces [
	<category: 'accessing'>

	^ #()
    ]

    classes [
	<category: 'accessing'>

	^ classes ifNil: [ classes := IdentitySet new ]
    ]

    isCategory [
	<category: 'testing'>

	^ true
    ]

    isNamespace [
	<category: 'testing'>

	^ false
    ]

    icon [
	<category: '*VisualGST'>

	^ self class icon
    ]
]
