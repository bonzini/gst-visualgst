Object extend [

    gtkInspect [
	"Open a GtkInspector on self"
	<category: 'debugging'>

	GtkLauncher.GtkInspector openOn: self
    ]

    inspectorView [
	<category: 'gtklauncher'>

	^ GtkLauncher.GtkObjectInspectorView
    ]
]

SequenceableCollection extend [
    inspectorView [
        <category: 'gtklauncher'>

        ^ GtkLauncher.GtkSequenceableCollectionInspectorView
    ]
]

Character extend [
    inspectorView [
        <category: 'gtklauncher'>

        ^ GtkLauncher.GtkCharacterInspectorView
    ]
]

Integer extend [
    inspectorView [
        <category: 'gtklauncher'>

        ^ GtkLauncher.GtkIntegerInspectorView
    ]
]

Float extend [
    inspectorView [
        <category: 'gtklauncher'>

        ^ GtkLauncher.GtkFloatInspectorView
    ]
]

Class extend [

    subclass: classNameString environment: aNamespace [
    "Define a subclass of the receiver with the given name.  If the class
     is already defined, don't modify its instance or class variables
     but still, if necessary, recompile everything needed."

    <category: 'instance creation'>
    | meta |
    KernelInitialized ifFalse: [^Smalltalk at: classNameString].
    meta := self metaclassFor: classNameString.
    ^meta 
        name: classNameString
        environment: aNamespace
        subclassOf: self
    ]
]

