Object subclass: MenuItem [

    MenuItem class >> on: aGtkBrowser [
	<category: 'instance creation'>

	^ self new
	    browser: aGtkBrowser;
	    yourself
    ]

    MenuItem class >> buildOn: aGtkBrowser [
	<category: 'instance creation'>

	^ (self on: aGtkBrowser)
			    build
    ]

    MenuItem class >> browserBuildOn: aGtkBrowser [
        <category: 'instance creation'>

        ^ (self on: aGtkBrowser)
                            browserBuild
    ]

    | browser |

    browser: aGtkBrowser [
	<category: 'accessing'>

	browser := aGtkBrowser
    ]

    browser [
	<category: 'accessing'>

	^ browser
    ]

    item [
	<category: 'accessing'>

    ]

    browserCommand [
	<category: 'accessing'>

    ]

    command [
	<category: 'accessing'>

    ]

    shortcut [
	<category: 'accessing'>

    ]

    build [
	<category: 'build'>

	^ (GTK.GtkMenuItem newWithLabel: self item)
                connectSignal: 'activate' to: self selector: #command;
                yourself
    ]

    browserBuild [
        <category: 'build'>

        ^ (GTK.GtkMenuItem newWithLabel: self item)
                connectSignal: 'activate' to: self selector: #browserCommand;
                yourself
    ]
]

