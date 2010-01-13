Object subclass: Category [
    | classes name parent subspaces |

    "<category: 'Language-Implementation'>"

    Category class [ | uniqueInstance | ]

    Category class >> named: aString [
	<category: 'accessing'>

	^ self basicNew
		    name: aString;
		    yourself
    ]

    Category class >> uniqueInstance [
	<category: 'accessing'>

	^ uniqueInstance ifNil: [ uniqueInstance := self basicNew ]
    ]

    Category class >> initialize [
	<category: 'initialize'>

	self extractCategory: Class
    ]

    Category class >> extractCategory: aClass [
	<category: 'extraction'>

        | category subcat token |
        token := aClass category ifNil: [ #() ] ifNotNil: [ aClass category tokenize: '-' ].
	category := self uniqueInstance.
	token do: [ :each |
	    (category subspaces includes: each) ifFalse: [ category subspaces at: each put: (Category named: each) ].
	    category := category subspaces at: each ].
	category classes add: aClass asClass.
	aClass subclassesDo: [ :each |
	    self extractCategory: each ]
    ]

    name: aString [
	<category: 'accessing'>

	name := aString
    ]

    name [
	<category: 'accessing'>

	^ name
    ]

    parent: aCategory [
	<category: 'accessing'>

	parent := aCategory
    ]

    parent [
	<category: 'accessing'>

	^ parent
    ]

    subspaces [
	<category: 'accessing'>

	^ subspaces ifNil: [ subspaces := Dictionary new ]
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
]
