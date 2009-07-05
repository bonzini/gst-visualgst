GTK.Gdk class extend [

    cairoCreate: aGdkWindow [
        <category: 'C call-outs'>

	<cCall: 'gdk_cairo_create' returning: #cObject args: #( #cObject )>
    ]
]

