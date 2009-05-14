UndoCommand subclass: RenameClassCommand [

    | class newClassName oldClassName treeStore |

    RenameClassCommand class >> rename: aClass as: aSymbol onModel: aGtkClassModel [
	<category: 'instance creation'>

	^ (self new)
	    rename: aClass as: aSymbol onModel: aGtkClassModel;
	    precondition;
	    yourself
    ]

    rename: aClass as: aSymbol onModel: aGtkClassModel [
	<category: 'initialize'>

	class := aClass.
	oldClassName := class name.
	newClassName := aSymbol.
	treeStore := aGtkClassModel
    ]

    description [
	<category: 'accessing'>

	^ 'Rename a class'
    ]

    precondition [
        <category: 'checking'>

        newClassName = #Smalltalk ifTrue: [ self error: 'class name can''t be the same has a namespace name'  ].
        Smalltalk subspacesDo: [ :each | each name = newClassName ifTrue: [ self error: 'class name can''t be the same has a namespace name'  ] ].
        (class environment findIndexOrNil: newClassName) ifNotNil: [ :class | self error: 'class exist in the namespace' ]
    ]

    undo [
	<category: 'events'>
	
	| iter |
        iter := treeStore findIterInAClass: class.
        treeStore at: iter column: 0 value: newClassName , ' class'.
        class setName: oldClassName.
        class environment at: oldClassName put: class.
        class environment removeKey: newClassName
    ]

    redo [
	<category: 'events'>

	| iter |
	iter := treeStore findIterInAClass: class.
	treeStore at: iter column: 0 value: newClassName , ' class'.
	class setName: newClassName.
	class environment at: newClassName put: class.
	class environment removeKey: oldClassName
    ]
]

