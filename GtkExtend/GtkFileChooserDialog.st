GTK.GtkFileChooserDialog class extend [

    for: aGtkFileChooserAction title: aString parent: aGtkWidget button: aGtkStock  [
        <category: 'instance creation'>

        ^ self
            new: aString
            parent: aGtkWidget
            action: aGtkFileChooserAction
            varargs: {GTK.Gtk gtkStockCancel.
                    GTK.Gtk gtkResponseCancel.
                    aGtkStock.
                    GTK.Gtk gtkResponseAccept.
                    nil}
    ]

    save: aString parent: aGtkWidget [
        <category: 'instance creation'>

        ^ self
            for: GTK.Gtk gtkFileChooserActionSave
            title: aString
            parent: aGtkWidget
            button: GTK.Gtk gtkStockSave
    ]

    load: aString parent: aGtkWidget [
        <category: 'instance creation'>

        ^ self
            for: GTK.Gtk gtkFileChooserActionOpen
            title: aString
            parent: aGtkWidget
            button: GTK.Gtk gtkStockOpen
    ]

    selectFolder: aString parent: aGtkWidget [
        <category: 'instance creation'>

        ^ self
            for: GTK.Gtk gtkFileChooserActionSelectFolder
            title: aString
            parent: aGtkWidget
            button: GTK.Gtk gtkStockOpen    
    ]
]

GTK.GtkFileChooserDialog extend [
    getFilename [
	<cCall: 'gtk_file_chooser_get_filename' returning: #string args: #( #self )>
    ]

    getCurrentFolder [
	<cCall: 'gtk_file_chooser_get_current_folder' returning: #string args: #( #self )>
    ]
]

