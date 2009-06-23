GTK.GtkButton class extend [

    label: aString onPressedSend: aSymbol to: anObject [
    <category: 'instance creation'>

    ^ (GTK.GtkButton newWithLabel: aString)
        connectSignal: 'pressed' to: anObject selector: aSymbol userData: nil;
        yourself
    ]
]

