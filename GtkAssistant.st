GtkBrowsingTool subclass: GtkAssistant [

    GtkAssistant class >> open [
	<category: 'user interface'>

	^ self openSized: 450@375
    ]

    aboutBrowser [
	<category: 'help events'>

	(GTK.GtkAboutDialog new)
	    setVersion: VisualGST version;
	    setLicense: VisualGST license;
	    setWebsite: VisualGST gstWebsite;
	    setComments: 'This is a GTK+ wrapper for GNU Smalltalk.';
	    setProgramName: 'GNU Smalltalk Launcher';
	    showModalDestroy
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

