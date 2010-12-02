Object subclass: Extension [

    Extension class >> for: aString method: aCompiledMethod [
	<category: 'instance-creation'>

	^ (MethodExtension for: aCompiledMethod methodClass)
		method: aCompiledMethod;
		classCategory: aString;
		yourself
    ]

    Extension class >> for: aClass ivar: aSymbol [
	<category: 'instance-creation'>

	^ (IVarExtension for: aClass)
		name: aSymbol;
		yourself
    ]

    Extension class >> for: aClass [
        <category: 'instance-creation'>

        ^ self new
	    classExtended: aClass;
	    yourself
    ]

    | class |

    classExtended: aClass [
	<category: 'accessing'>
   
	class := aClass 
    ]

    classExtended [
	<category: 'accessing'>
    
	^ class
    ]

    printOn: aStream [
	<category: 'printing'>

	aStream
	    nextPutAll: self kindOfExtension, ' '.
	self classExtended printOn: aStream.
    ]
]

Extension subclass: MethodExtension [

    | method classCategory |

    method: aSymbol [
	<category: 'accessing'>
   
	method := aSymbol 
    ]

    method [
	<category: 'accessing'>
    
	^ method
    ]

    classCategory: aString [
	<category: 'accessing'>
   
	classCategory := aString 
    ]

    classCategory [
	<category: 'accessing'>
    
	^ classCategory
    ]

    kindOfExtension [
	<category: 'printing'>

	^ 'Method extension'
    ]

    printOn: aStream [
        <category: 'printing'>

	super printOn: aStream.
	self method printOn: aStream.
	aStream nextPutAll: ' category : '.
	self classCategory printOn: aStream
    ]
]

Extension subclass: IVarExtension [

    | name |

    name: aSymbol [
	<category: 'accessing'>
  
	name := aSymbol
    ]

    name [
	<category: 'accessing'>
   
	^ name
    ]

    kindOfExtension [
        <category: 'printing'>

        ^ 'Instance variable extension'
    ]

    printOn: aStream [
        <category: 'printing'>

        super printOn: aStream.
	self name printOn: aStream
    ]
]


AbstractNamespace class extend [
    NamespaceExtends := nil.

    namespaceExtends [
        ^ NamespaceExtends ifNil: [ NamespaceExtends := WeakKeyIdentityDictionary new ]
    ]
]

AbstractNamespace extend [

    namespaceExtends [

        ^ self class namespaceExtends at: self ifAbsentPut: [ Dictionary new ]
    ]

    for: aClass addExtension: anExtension [

	^ (self namespaceExtends at: aClass ifAbsentPut: [ Set new ])
			    add: anExtension
    ]

    addExtension: anExtension [

	^ self for: anExtension classExtended addExtension: anExtension
    ]
]

Behavior extend [

    namespace: aNamespace instVarNames: aString [

        aString subStrings do: [ :each |
            self instVarName: each for: aNamespace ]
    ]

    instVarName: aString for: aNamespace [

        self addInstVarName: aString.
        aNamespace addExtension: (Extension for: self ivar: aString)
    ]
]

Eval [
    Object registerHandler: [ :mth :msg |
            msg argument addExtension: (Extension for: (msg arguments at: 2) method: mth).
            mth methodCategory: (msg arguments at: 3).
            nil ] forPragma: #'namespace:classCategory:category:'.

    Object registerHandler: [ :mth :msg |
            msg argument addExtension: (Extension for: '' method: mth).
            mth methodCategory: (msg arguments at: 2).
            nil ] forPragma: #'namespace:category:'.
]

