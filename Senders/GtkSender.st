GtkBrowserWrapper subclass: GtkSender [
    GtkSender class [ | LiteralsAndSpecialSelectors | ]

    GtkSender class >> literalsAndSpecialSelectors [
        <category: 'accessing'>

        ^ LiteralsAndSpecialSelectors ifNil: [
            LiteralsAndSpecialSelectors := Dictionary new.
            [ CompiledMethod allInstancesDo: [ :each |
                each literalsAndSpecialSelectorsDo: [ :lit |
		    lit isSymbol 
			ifTrue: [ (LiteralsAndSpecialSelectors at: lit ifAbsentPut: [ OrderedCollection new ]) add: each ]
			ifFalse: [  "lit isClass ifTrue: [ lit displayString printNl.
					    (LiteralsAndSpecialSelectors at: lit displayString asSymbol ifAbsentPut: [ OrderedCollection new ]) add: each ]" ]
				 ] ] ] fork.
            LiteralsAndSpecialSelectors ]
    ]

    | currentMethod senderResults |

    selector: aSymbol [
	<category: 'accessor'>

        selector := aSymbol.
        self resultModel clear.
	self findInMethod: (imageWidget matchSelector: aSymbol) values first element.
    ]

    aboutSender [
        <category: 'events'>

        (GTK.GtkAboutDialog new)
            setVersion: VisualGST version;
            setLicense: 'Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is furnished
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.';
            setWebsite: VisualGST website;
            setComments: 'This is a GTK+ wrapper for GNU Smalltalk.';
            setProgramName: 'GNU Smalltalk Sender';
            run
    ]

    findInMethod: anObject [
	<category: 'find'>

	| to |	
	senderResults := Dictionary new.
	(self literalsAndSpecialSelectors at: anObject displaySymbol ifAbsent: [ #() ] ) do: [ :each |
	    self resultModel appendItem: {each displayString}.
	    senderResults at: each displayString put: each ].
    ]

    literalsAndSpecialSelectors [
	<category: 'accessing'>

	^ self class literalsAndSpecialSelectors
    ]

    resultSelected [
	<category: 'sender events'>

	| count iter path selectedIter selectedString string |
        (selectedIter := resultTree selectedIter) ifNil: [ ^ self ].
        selectedString := (self resultModel getOop: selectedIter column: 0).
	currentMethod := senderResults at: selectedString ifAbsent: [ ^ self error: selectedString, 'not in the list' ].

        classBrowserWidget
                selectANamespace: currentMethod methodClass environment;
                selectAClass: (currentMethod methodClass isClass ifTrue: [ currentMethod methodClass ] ifFalse: [ currentMethod methodClass instanceClass ]).
        currentMethod methodClass isClass
                ifTrue: [ classBrowserWidget selectAnInstanceMethod: currentMethod selector ]
                ifFalse: [ classBrowserWidget selectAClassMethod: currentMethod selector  ]
    ]

]

