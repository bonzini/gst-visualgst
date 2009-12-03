Command subclass: UndoableCommand [
    UndoableCommand class [ | UndoStack | ]

    UndoableCommand class >> undoStack [
	<category: 'accessing'>

	^ UndoStack ifNil: [ UndoStack := GtkClassBrowserWidget undoStack ]
    ]

    undoStack [
	<category: 'accessing'>

	^ self class undoStack 
    ]

    push: anUndoCommand [
	<category: 'accessing'>

	anUndoCommand precondition ifFalse: [ ^ self displayError: anUndoCommand ].
	self undoStack push: anUndoCommand
    ]

    displayError: anUndoCommand [
	<Category: 'error'>

	| dialog |
        dialog := GTK.GtkMessageDialog
                                new: nil 
                                flags: GTK.Gtk gtkDialogDestroyWithParent
                                type: GTK.Gtk gtkMessageWarning
                                buttons: GTK.Gtk gtkButtonsNone
                                message: anUndoCommand description
                                tip: anUndoCommand error.

        dialog
            addButton: 'Ok' responseId: 1;
            runBlockingAndDo: [ :dlg :res | dlg destroy ].
    ]

]

