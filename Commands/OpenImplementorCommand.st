Command subclass: OpenImplementorCommand [

    openWithSelection [
	<category: 'focus checking'>


        (VisualGST uniqueInstance notebookHasFocus and:
	    [ VisualGST uniqueInstance onFocusPerform: #hasSelection ])
                ifTrue: [ GtkImplementor openOn: ( STInST.RBParser selectedSymbol: (VisualGST uniqueInstance onFocusPerform: #selectedText)) ]
                ifFalse: [ GtkImplementor open ]
    ]

    focusChecking [
	<category: 'focus checking'>

	VisualGST uniqueInstance browserHasFocus
                    ifTrue: [
                        (VisualGST uniqueInstance currentWidgetOfBrowser sourceCodeWidgetHasFocus 
			    and: [ VisualGST uniqueInstance currentWidgetOfBrowser hasSelection ])
                                                            ifTrue: [
								    GtkImplementor openOn: ( STInST.RBParser selectedSymbol: 
													    VisualGST uniqueInstance currentWidgetOfBrowser selectedText) ]
                                                            ifFalse: [ 
								    VisualGST uniqueInstance currentWidgetOfBrowser hasSelectedMethod ifTrue: [
									GtkImplementor openOn: VisualGST uniqueInstance currentWidgetOfBrowser selectedMethodSymbol ]
																      ifFalse: [ GtkImplementor open ] ] ]
                    ifFalse: [ self openWithSelection ]
    ]

    execute [
        <category: 'command'>

        target
            ifNotNil: [ GtkImplementor openOn: target selectedMethodSymbol ]
            ifNil: [ self focusChecking ]
    ]
]

