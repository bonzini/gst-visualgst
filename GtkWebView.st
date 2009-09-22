GTK.GtkWidget subclass: GtkWebView [

    GtkWebView class >> registerDLD [
	<category: 'C call-outs'>

	DLD addLibrary: 'libwebkit-1.0'
    ]

    GtkWebView class >> hasWebkit [
	<category: 'testing'>

	^ CFunctionDescriptor isFunction: 'webkit_web_view_new'
    ]

    GtkWebView class >> new [
	<category: 'C call-outs'>

	<cCall: 'webkit_web_view_new' returning: #{GtkWebView} args: #( )>
    ]

    openUrl: aString [
	<category: 'C call-outs'>

	<cCall: 'webkit_web_view_open' returning: #void args: #( #self #string )>
    ]
]

