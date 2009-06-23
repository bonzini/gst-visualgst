GTK.GtkScrolledWindow class extend [

    withChild: aGtkWidget [
    <category: 'instance creation'>

    ^ (GTK.GtkScrolledWindow new: nil vadjustment: nil)
        add: aGtkWidget;
        setPolicy: GTK.Gtk gtkPolicyAutomatic vscrollbarPolicy: GTK.Gtk gtkPolicyAutomatic;
        yourself
    ]
]

