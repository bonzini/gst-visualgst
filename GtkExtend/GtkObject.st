GTK.GtkObject extend [
    signalEmit: signal args: argsArray [
        <category: 'C call-outs'>
        <cCall: 'gtk_signal_emit' returning: #void
        args: #(#self #int #variadic)>

    ]

    signalEmitByName: signal args: argsArray [
        <category: 'C call-outs'>
        <cCall: 'gtk_signal_emit_by_name' returning: #void
        args: #(#self #string #variadic)>

    ]

    signalNEmissions: signal [
        <category: 'C call-outs'>
        <cCall: 'gtk_signal_n_emissions' returning: #int
        args: #(#self #int)>

    ]

    signalNEmissionsByName: signal [
        <category: 'C call-outs'>
        <cCall: 'gtk_signal_n_emissions_by_name' returning: #int
        args: #(#self #string)>

    ]

    signalEmitStop: signal [
        <category: 'C call-outs'>
        <cCall: 'gtk_signal_emit_stop' returning: #void
        args: #(#self #int)>

    ]

    signalEmitStopByName: signal [
        <category: 'C call-outs'>
        <cCall: 'gtk_signal_emit_stop_by_name' returning: #void
        args: #(#self #string)>

    ]
]

