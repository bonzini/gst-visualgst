Eval [
    PackageLoader fileInPackage: 'VisualGST'.
    VisualGST.GtkWebView registerDLD.
    VisualGST.VisualGST uniqueInstance.
    GTK.Gtk main
]

