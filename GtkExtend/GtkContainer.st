GTK.GtkContainer extend [

    getFocusChild [
	<category: '*VisualGST'>

	<cCall: 'gtk_container_get_focus_child' returning: #{GtkWidget}
	args: #( #self )>
    ]

    focusChildFor: aGtkWindow [
	<category: '*VisualGST'>

	| child parent |
	parent := child := self.
	[ (child := parent getFocusChild) isNil not ] whileTrue: [
	    parent := child ].
	^ aGtkWindow getFocus address = parent address
    ]
]

