Eval [
    PackageLoader fileInPackage: 'GtkLauncher'.
    GTK.Gtk gstGtkInit.
    GtkLauncher.GtkLauncher open.
    GTK.Gtk main
]

