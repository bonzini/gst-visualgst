"======================================================================
|
|   GTK Tetris... why not?
|
|
 ======================================================================"

"======================================================================
|
| Copyright 1999 Free Software Foundation, Inc.
| Written by Paolo Bonzini, Gwenael Casaccio.
|
| This file is part of GNU Smalltalk.
|
| GNU Smalltalk is free software; you can redistribute it and/or modify it
| under the terms of the GNU General Public License as published by the Free
| Software Foundation; either version 2, or (at your option) any later version.
| 
| GNU Smalltalk is distributed in the hope that it will be useful, but WITHOUT
| ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
| FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
| details.
| 
| You should have received a copy of the GNU General Public License along with
| GNU Smalltalk; see the file LICENSE.  If not, write to the Free Software
| Foundation, 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  
|
 ======================================================================"

Object subclass: TetrisPiece [
    | positions rotation color origin |
    
    <category: 'Graphics-Tetris'>
    <comment: nil>

    BlockSize := nil.
    Pieces := nil.

    TetrisPiece class >> blockSize [
	<category: 'pieces'>

	^ 12
    ]

    TetrisPiece class >> initialize [
	"Initialize the class variables"

	<category: 'pieces'>
	BlockSize := self blockSize.
	Pieces := (Array new: 7)
		    at: 1 put: (TetrisPiece new color: 'DarkKhaki' initialize: self pieceL);
		    at: 2 put: (TetrisPiece new color: 'Magenta' initialize: self pieceJ);
		    at: 3 put: (TetrisPiece new color: 'Red' initialize: self pieceI);
		    at: 4 put: (TetrisPiece new color: 'BlueViolet' initialize: self pieceO);
		    at: 5 put: (TetrisPiece new color: 'Cyan' initialize: self pieceS);
		    at: 6
			put: (TetrisPiece new color: 'DarkOrange' initialize: self pieceZ);
		    at: 7 put: (TetrisPiece new color: 'ForestGreen' initialize: self pieceT);
		    yourself
    ]

    TetrisPiece class >> pieceL [
	<category: 'pieces'>
	^#( #(1 0 0 0)
	    #(1 0 0 0) 
	    #(1 1 0 0) 
	    #(0 0 0 0) 
	    #(1 1 1 0) 
	    #(1 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(1 1 0 0) 
	    #(0 1 0 0) 
	    #(0 1 0 0) 
	    #(0 0 0 0) 
	    #(0 0 1 0) 
	    #(1 1 1 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0))
    ]

    TetrisPiece class >> pieceJ [
	<category: 'pieces'>
	^#( #(0 1 0 0) 
	    #(0 1 0 0) 
	    #(1 1 0 0) 
	    #(0 0 0 0) 
	    #(1 0 0 0) 
	    #(1 1 1 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(1 1 0 0) 
	    #(1 0 0 0) 
	    #(1 0 0 0) 
	    #(0 0 0 0) 
	    #(1 1 1 0) 
	    #(0 0 1 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0))
    ]

    TetrisPiece class >> pieceI [
	<category: 'pieces'>
	^#( #(1 0 0 0) 
	    #(1 0 0 0) 
	    #(1 0 0 0) 
	    #(1 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(1 1 1 1) 
	    #(1 0 0 0) 
	    #(1 0 0 0) 
	    #(1 0 0 0) 
	    #(1 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(1 1 1 1))
    ]

    TetrisPiece class >> pieceO [
	<category: 'pieces'>
	^#( #(1 1 0 0) 
	    #(1 1 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(1 1 0 0) 
	    #(1 1 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(1 1 0 0) 
	    #(1 1 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(1 1 0 0) 
	    #(1 1 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0))
    ]

    TetrisPiece class >> pieceS [
	<category: 'pieces'>
	^#( #(0 1 0 0) 
	    #(1 1 0 0) 
	    #(1 0 0 0) 
	    #(0 0 0 0) 
	    #(1 1 0 0) 
	    #(0 1 1 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 1 0 0) 
	    #(1 1 0 0) 
	    #(1 0 0 0) 
	    #(0 0 0 0) 
	    #(1 1 0 0) 
	    #(0 1 1 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0))
    ]

    TetrisPiece class >> pieceZ [
	<category: 'pieces'>
	^#( #(1 0 0 0) 
	    #(1 1 0 0) 
	    #(0 1 0 0) 
	    #(0 0 0 0) 
	    #(0 1 1 0) 
	    #(1 1 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(1 0 0 0) 
	    #(1 1 0 0) 
	    #(0 1 0 0) 
	    #(0 0 0 0) 
	    #(0 1 1 0) 
	    #(1 1 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0))
    ]

    TetrisPiece class >> pieceT [
	<category: 'pieces'>
	^#( #(0 1 0 0) 
	    #(1 1 1 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0)
	    #(1 0 0 0) 
	    #(1 1 0 0) 
	    #(1 0 0 0) 
	    #(0 0 0 0) 
	    #(1 1 1 0) 
	    #(0 1 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 1 0 0) 
	    #(1 1 0 0) 
	    #(0 1 0 0) 
	    #(0 0 0 0))
    ]

    TetrisPiece class >> random [
	<category: 'pieces'>
	| piece |
	piece := Random between: 1 and: 7.
	^ (Pieces at: piece) copy
    ]

    color: myColor initialize: table [
	<category: 'initializing'>

	color := myColor.
	rotation := 1.
	positions := Array 
		    with: (table copyFrom: 1 to: 4)
		    with: (table copyFrom: 5 to: 8)
		    with: (table copyFrom: 9 to: 12)
		    with: (table copyFrom: 13 to: 16)
    ]

    cementOn: field [
	<category: 'blocks'>

        | point x y |
        point := Point new.
        y := 0.
        (positions at: rotation) do: [ :line |
                    x := 0.
                    line do: [ :elem |
                        elem = 1 ifTrue: [
                            point
                                x: self origin x + x;
                                y: self origin y + y.
                            (field at: point) = 0 ifTrue: [ field at: point put: elem ] ].
			x := x + 1 ].
		    y := y + 1].
    ]

    blockSize [
	<category: 'drawing'>

	^ BlockSize
    ]

    color [
	<category: 'drawing'>

	^ color
    ]

    canMoveInto: field [
	<category: 'moving'>

	| point x y |
	point := Point new.
	y := 0.
	(positions at: rotation) do: [ :line |
		    x := 0.
		    line do: [ :elem | 
			elem = 1 ifTrue: [ 
			    point
				x: self origin x + x;
				y: self origin y + y.
			    (field at: point) > 0 ifTrue: [ ^ false ] ].
			x := x + 1 ].
		    y := y + 1 ].
	^ true
    ]

    moveInto: field ifFail: aBlock [
	<category: 'moving'>

	(self canMoveInto: field) ifFalse: [ aBlock value.
				    ^ false ].
	^ true
    ]

    rotate: howMany [
	"Three lines are necessary because rotation is in the 1..4 range,
	 while \\ likes a 0..3 range"

	<category: 'moving'>
	rotation := rotation - 1.
	rotation := (rotation + howMany) \\ 4.
	rotation := rotation + 1
    ]

    origin [
	<category: 'accessing'>
	^origin
    ]

    x [
	<category: 'accessing'>
	^self origin x
    ]

    x: x [
	<category: 'accessing'>
	self origin x: x
    ]

    y [
	<category: 'accessing'>
	^self origin y
    ]

    y: y [
	<category: 'accessing'>
	self origin y: y
    ]

    drawOn: aCanvas [
	<category: 'drawing'>

	| y |
	y := 0.
        (positions at: rotation) do: [ :line |
	    y := y + 1.
            1 to: 4 do: [ :x |
                (line at: x) ~= 0 ifTrue: [
                    BlockWidget new
                        position: (50 + ((self x + x - 1) * 15))@(50 + ((self y + y - 1) * 15));
                        size: 15;
                        drawOn: aCanvas ] ] ]
    ]

    postCopy [
	<category: 'basic'>
	rotation := 1.
	origin := Point new
    ]
]

