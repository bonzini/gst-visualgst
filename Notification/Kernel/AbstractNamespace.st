Smalltalk.AbstractNamespace class extend [

    primNew: parent name: spaceName [
	"Private - Create a new namespace with the given name and parent, and
	add to the parent a key that references it."

	<category: 'instance creation'>
	| namespace |
	(parent at: spaceName ifAbsent: [ nil ]) isNamespace 
	    ifTrue: [ ^ parent at: spaceName asGlobalKey ].
	namespace := parent 
			at: spaceName asGlobalKey
			put: ((super new: 24)
				    setSuperspace: parent;
				    name: spaceName asSymbol;
				    yourself).
	VisualGST.SystemChangeNotifier uniqueInstance namespaceAdded: namespace.
	^ namespace
    ]

]

