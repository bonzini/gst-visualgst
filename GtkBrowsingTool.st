GtkVisualGSTTool subclass: GtkBrowsingTool [
    <comment: 'I am the base for various browsers of VisualGST.'>

    state [
        <category: 'command protocols'>

        self subclassResponsibility
    ]

    acceptIt [
        <category: 'command protocols'>

        self subclassResponsibility
    ]

    onDelete [
        <category: 'window events'>

        self hasChanged ifFalse: [ ^ window hideAll ].
        self saveCodeOnClose: [ window hideAll ] onSave: [ self acceptIt. window hideAll ].
        ^ true
    ]

    saveCodeOnClose: closeEvent onSave: saveEvent [
        <category: 'saving'>

        | dialog |
        dialog := GTK.GtkMessageDialog
                                new: window
                                flags: GTK.Gtk gtkDialogDestroyWithParent
                                type: GTK.Gtk gtkMessageWarning
                                buttons: GTK.Gtk gtkButtonsNone
                                message: 'Save the code before exiting?'
                                tip: 'If you do not save, your changes to %1 will be lost...' % {self state}.

        dialog
            addButton: 'Close without saving' responseId: 0;
            addButton: 'Cancel' responseId: 2;
            addButton: 'Save' responseId: 1;
            showModalOnAnswer: [ :dlg :res |
                res = 0 ifTrue: closeEvent.
                res = 1 ifTrue: saveEvent.
                dlg destroy ].
    ]

    checkCodeWidget [
        <category: 'text editing'>

        self hasChanged ifFalse: [ self clearUndo. ^ self ].
        self saveCodeOnSave: [ self acceptIt ].
        self clearUndo
    ]

    saveCodeOnSave: saveEvent [
        <category: 'saving'>

        | dialog |
        dialog := GTK.GtkMessageDialog
                                new: window
                                flags: GTK.Gtk gtkDialogDestroyWithParent
                                type: GTK.Gtk gtkMessageWarning
                                buttons: GTK.Gtk gtkButtonsNone
                                message: 'Save changes to this method?'
                                tip: 'If you do not save, your changes to %1 will be lost...' % {self state}.

        dialog
            addButton: 'Cancel' responseId: 0;
            addButton: 'Save' responseId: 1;
            showModalOnAnswer: [ :dlg :res |
                res = 1 ifTrue: saveEvent.
                dlg destroy ].
    ]

    hasChanged [
        <category: 'testing'>

        self subclassResponcibility
    ]

    clearUndo [
	<category: 'undo'>

	
        self subclassResponcibility
    ]

]

