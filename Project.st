Object subclass: Project [
    | authors licence name namespace workspace |

    addAuthor: aString [
    ]

    authors: anArray [
    ]

    authors [
    ]

    licence: aString [
    ]

    licence [
    ]

    name: aString [
	name := aString
    ]

    name [
	^ name
    ]

    namespace: aNamespace [
	namespace := aNamespace
    ]

    namespace [
    ]

    workspace: aPath [
	workspace := aPath
    ]

    workspace [
	^ workspace
    ]
]

