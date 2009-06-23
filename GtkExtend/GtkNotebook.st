GTK.GtkNotebook extend [

    pageNum: aGtkWidget [
    <category: 'C call-outs'>

    <cCall: 'gtk_notebook_page_num' returning: #int args: #( #self #cObject )>
    ]
]

