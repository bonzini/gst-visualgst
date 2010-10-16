STInST.STInST.RBProgramNodeVisitor subclass: WorkspaceVariableTracker [
    | keyword object |

    initialize [
        <category: 'initialization'>

        | class |
        keyword := #('self' 'super' 'true' 'false' 'nil' 'thisContext') asSet.
	class := (Behavior new)
                    superclass: Object;
                    yourself.
        object := class new.
    ]

    object [
        <category: 'accessing'>

        ^ object
    ]

    objectClass [
        <category: 'accessing'>

        ^ object class
    ]

    includesVariable: aString [
        <category: 'operation'>

        ^ aString first isUppercase or: [ (keyword includes: aString) or: [ self objectClass allInstVarNames includes: aString asSymbol ] ]
    ]

    defineVariable: aString [
        <category: 'operation'>

        self objectClass addInstVarName: aString
    ]

    removeVariable: aString [
	<category: 'operation'>

        self objectClass removeInstVarName: aString
    ]

    checkAndAdd: aString [
	<category: 'operation'>

        (self includesVariable: aString)
            ifFalse: [ self defineVariable: aString ].
    ]

    acceptAssignmentNode: anRBAssignmentNode [
        <category: 'operation'>

	self checkAndAdd: anRBAssignmentNode variable name.
        self visitNode: anRBAssignmentNode value
    ]

    acceptVariableNode: anRBVariableNode [
        <category: 'operation'>

	self checkAndAdd: anRBVariableNode name
    ]

]
