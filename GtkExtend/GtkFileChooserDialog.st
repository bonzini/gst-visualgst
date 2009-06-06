GTK.GtkFileChooserDialog extend [

    getFilename [
	<cCall: 'gtk_file_chooser_get_filename' returning: #string args: #( #self )>
    ]
]

