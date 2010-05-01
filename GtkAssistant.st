GtkBrowsingTool subclass: GtkAssistant [

    GtkAssistant class >> open [
	<category: 'user interface'>

	^ self openSized: 450@375
    ]

    windowTitle [
	^ 'Assistant'
    ]

    aboutTitle [
	^ 'About Assistant'
    ]

    buildCentralWidget [
	<category: 'intialize-release'>

        | webview |

        webview := GtkWebView new
                        openUrl: 'http://library.gnome.org/devel/gtk/stable/index.html';
                        showAll;
                        yourself.

	^ (GTK.GtkScrolledWindow withChild: webview)
	    showAll; 
	    yourself
    ]
]

