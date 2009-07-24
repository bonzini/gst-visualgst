"======================================================================
|
|   GTK Tetris... why not?
|
|
 ======================================================================"

"======================================================================
|
| Copyright 1999 Free Software Foundation, Inc.
| Written by Paolo Bonzini.
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


Object subclass: TetrisField [
    | rows currentPiece nextPiece |
    
    <category: 'Graphics-Tetris'>
    <comment: nil>

    TetrisField class >> new [
	<category: 'instance creation'>
	^ self basicNew initialize
    ]

    at: point [
	<category: 'accessing'>
	^(rows at: point y) at: point x
    ]

    at: point put: value [
	<category: 'accessing'>
	^(rows at: point y) at: point x put: value
    ]

    initialize [
	<category: 'initializing'>
	
	rows := (1 to: 28) collect: [:each | ByteArray new: 14].
	rows do: [:each | self initializeLine: each].
	(rows at: 25) atAllPut: 1
    ]

    initializeLine: line [
	<category: 'initializing'>
	line
	    at: 1 put: 1;
	    at: 2 put: 1;
	    atAll: (3 to: 12) put: 0;
	    at: 13 put: 1;
	    at: 14 put: 1
    ]

    checkLine: y [
	<category: 'removing filled lines'>
	^(rows at: y) allSatisfy: [:each | each ~~ 0]
    ]

    removeLines [
	<category: 'removing filled lines'>
	| removed lastLine firstLine |
	removed := 0.
	firstLine := self currentPiece y.
	lastLine := 24 min: firstLine + 3.
	lastLine - firstLine + 1 timesRepeat: 
		[(self checkLine: lastLine) 
		    ifTrue: 
			[removed := removed + 1.
			self removeLine: lastLine]
		    ifFalse: [lastLine := lastLine - 1]].
	^removed
    ]

    removeLine: filledY [
	<category: 'removing filled lines'>
	| saved y shift line |
	saved := rows at: filledY.
	filledY to: 2
	    by: -1
	    do: [:each | rows at: each put: (rows at: each - 1)].
	self initializeLine: saved.
	rows at: 1 put: saved.

	"Now take care of the canvas"
	"y := filledY * TetrisPiece blockSize.
	shift := 0 @ TetrisPiece blockSize.
	line := Rectangle origin: -1 @ (y + 2)
		    corner: (15 * TetrisPiece blockSize) @ (y + 4).
	canvas items do: 
		[:each | 
		each origin y < line origin y 
		    ifTrue: 
			[each corner y > line corner y 
			    ifTrue: [each remove]
			    ifFalse: 
				[each
				    moveBy: shift;
				    redraw]]]"
    ]

    dropPiece [
	<category: 'moving pieces'>
	[self slidePiece] whileTrue: []
    ]

    movePieceLeft [
	<category: 'moving pieces'>
	self currentPiece x: self currentPiece x - 1.
	^self currentPiece moveInto: self
	    ifFail: [self currentPiece x: self currentPiece x + 1]
    ]

    movePieceRight [
	<category: 'moving pieces'>
	self currentPiece x: self currentPiece x + 1.
	^self currentPiece moveInto: self
	    ifFail: [self currentPiece x: self currentPiece x - 1]
    ]

    rotatePiece [
	<category: 'moving pieces'>
	self currentPiece rotate: 1.
	^self currentPiece moveInto: self ifFail: [self currentPiece rotate: 3]
    ]

    slidePiece [
	<category: 'moving pieces'>
	self currentPiece y: self currentPiece y + 1.
	^self currentPiece moveInto: self
	    ifFail: [self currentPiece y: self currentPiece y - 1]
    ]

    currentPiece [
	<category: 'accessing piece variables'>
	^currentPiece
    ]

    currentPiece: piece [
	<category: 'accessing piece variables'>
	currentPiece := piece.
	(self currentPiece)
	    x: 4;
	    y: 1
    ]

    nextPiece [
	<category: 'accessing piece variables'>
	^nextPiece
    ]

    nextPiece: piece [
	<category: 'accessing piece variables'>
	nextPiece := piece
    ]
]


Object subclass: TetrisPiece [
    | positions blocks rotation color origin |
    
    <category: 'Graphics-Tetris'>
    <comment: nil>

    BlockSize := nil.
    Pieces := nil.

    TetrisPiece class >> blockSize [
	<category: 'pieces'>
	^12
    ]

    TetrisPiece class >> initialize [
	"Initialize the class variables"

	<category: 'pieces'>
	BlockSize := self blockSize.
	Pieces := (Array new: 7)
		    at: 1 put: (TetrisPiece new color: 'DarkKhaki' initialize: self pieceL);
		    at: 2
			put: (TetrisPiece new color: 'Magenta' initialize: self pieceInvertedL);
		    at: 3 put: (TetrisPiece new color: 'Red' initialize: self pieceSkinny);
		    at: 4
			put: (TetrisPiece new color: 'BlueViolet' initialize: self pieceBlock);
		    at: 5 put: (TetrisPiece new color: 'Cyan' initialize: self pieceSlash);
		    at: 6
			put: (TetrisPiece new color: 'DarkOrange' initialize: self pieceBackslash);
		    at: 7 put: (TetrisPiece new color: 'ForestGreen' initialize: self pieceT);
		    yourself
    ]

    TetrisPiece class >> pieceL [
	<category: 'pieces'>
	^#( #(0 0 0 0)
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 8 8 0) 
	    #(0 0 0 0) 
	    #(0 0 8 0) 
	    #(8 8 8 0) 
	    #(0 8 0 0) 
	    #(8 0 0 0) 
	    #(0 0 8 0) 
	    #(0 0 8 0) 
	    #(0 8 0 0) 
	    #(8 8 8 0) 
	    #(0 8 8 0))
    ]

    TetrisPiece class >> pieceInvertedL [
	<category: 'pieces'>
	^#( #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(8 0 0 0) 
	    #(0 0 0 0) 
	    #(8 8 0 0) 
	    #(8 8 8 0) 
	    #(8 0 0 0) 
	    #(0 0 8 0) 
	    #(0 8 0 0) 
	    #(8 0 0 0) 
	    #(8 8 0 0) 
	    #(8 8 8 0) 
	    #(0 8 0 0))
    ]

    TetrisPiece class >> pieceSkinny [
	<category: 'pieces'>
	^#( #(0 8 0 0) 
	    #(0 0 0 0) 
	    #(0 8 0 0) 
	    #(0 0 0 0) 
	    #(0 8 0 0) 
	    #(0 0 0 0) 
	    #(0 8 0 0) 
	    #(0 0 0 0) 
	    #(0 8 0 0) 
	    #(8 8 8 8) 
	    #(0 8 0 0) 
	    #(8 8 8 8) 
	    #(0 8 0 0) 
	    #(0 0 0 0) 
	    #(0 8 0 0) 
	    #(0 0 0 0))
    ]

    TetrisPiece class >> pieceBlock [
	<category: 'pieces'>
	^#( #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 8 8 0) 
	    #(0 8 8 0) 
	    #(0 8 8 0) 
	    #(0 8 8 0) 
	    #(0 8 8 0) 
	    #(0 8 8 0) 
	    #(0 8 8 0) 
	    #(0 8 8 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0))
    ]

    TetrisPiece class >> pieceSlash [
	<category: 'pieces'>
	^#( #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 8 0) 
	    #(0 0 0 0) 
	    #(0 0 8 0) 
	    #(0 0 0 0) 
	    #(0 8 8 0) 
	    #(8 8 0 0) 
	    #(0 8 8 0) 
	    #(8 8 0 0) 
	    #(0 8 0 0) 
	    #(0 8 8 0) 
	    #(0 8 0 0) 
	    #(0 8 8 0))
    ]

    TetrisPiece class >> pieceBackslash [
	<category: 'pieces'>
	^#( #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 8 0 0) 
	    #(0 0 0 0) 
	    #(0 8 0 0) 
	    #(0 0 0 0) 
	    #(0 8 8 0) 
	    #(0 8 8 0) 
	    #(0 8 8 0) 
	    #(0 8 8 0) 
	    #(0 0 8 0) 
	    #(8 8 0 0) 
	    #(0 0 8 0) 
	    #(8 8 0 0))
    ]

    TetrisPiece class >> pieceT [
	<category: 'pieces'>
	^#( #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0) 
	    #(0 0 0 0)
	    #(0 8 0 0) 
	    #(0 0 0 0) 
	    #(0 0 8 0) 
	    #(8 8 8 0) 
	    #(0 8 8 0) 
	    #(0 8 0 0) 
	    #(0 8 8 0) 
	    #(0 8 0 0) 
	    #(0 8 0 0) 
	    #(8 8 8 0) 
	    #(0 0 8 0) 
	    #(0 0 0 0))
    ]

    TetrisPiece class >> random [
	<category: 'pieces'>
	| piece |
	piece := Random between: 1 and: 7.
	^(Pieces at: piece) copy
    ]

    color: myColor initialize: table [
	<category: 'initializing'>
	color := myColor.
	positions := Array 
		    with: (self getPiece: table index: 1)
		    with: (self getPiece: table index: 2)
		    with: (self getPiece: table index: 3)
		    with: (self getPiece: table index: 4)
    ]

    getPiece: table index: index [
	"Private - Answer an array of four points corresponding to the coordinates
	 of the points in table which are such that table[y*4 + x + index] <> 0.
	 table[index+12]. This is necessary so that a human being can prepare the
	 tables..."

	<category: 'initializing'>
	| firstFree y position |
	firstFree := 1.
	y := 0.
	position := Array new: 4.
	index to: index + 12
	    by: 4
	    do: 
		[:each | 
		firstFree := self 
			    getPiece: (table at: each)
			    y: y
			    blocksFrom: firstFree
			    storeIn: position.
		y := y + 1].
	^position
    ]

    getPiece: tableLine y: y blocksFrom: firstFree storeIn: blocks [
	"Private - Store in the blocks Array, starting at index firstFree,
	 points with the given y and varying x, corresponding to any
	 values <> 0 in the tableLine Array.
	 Answer the index, >= firstFree, of the last slot filled in blocks."

	<category: 'initializing'>
	| i |
	i := firstFree.
	tableLine doWithIndex: 
		[:each :x | 
		each = 0 
		    ifFalse: 
			[blocks at: i put: x @ y.
			i := i + 1]].
	^i
    ]

    blockSize [
	<category: 'drawing'>
	^BlockSize
    ]

    cementOn: field" drawOn: canvas" [
	<category: 'drawing'>
	"blocks do: 
		[:eachCoord | 
		field at: eachCoord / self blockSize put: 1.
		(BRectangle new: canvas)
		    color: self color;
		    grayOut;
		    origin: eachCoord extent: self blockSize asPoint;
		    create]"
    ]

    color [
	<category: 'drawing'>
	^color
    ]

    drawWith: movingBlocks [
	<category: 'drawing'>
	movingBlocks with: blocks
	    do: 
		[:eachBRect :eachCoord | 
		"eachBRect
		    origin: eachCoord extent: self blockSize asPoint;
		    redraw"]
    ]

    canMoveInto: field [
	<category: 'moving'>
	| point |
	point := Point new.
	(positions at: rotation) do: 
		[:position | 
		point
		    x: self origin x + position x;
		    y: self origin y + position y.
		(field at: point) > 0 ifTrue: [^false]].
	^true
    ]

    move [
	<category: 'moving'>
	blocks with: (positions at: rotation)
	    do: 
		[:block :position | 
		block
		    x: (self origin x + position x) * self blockSize;
		    y: (self origin y + position y) * self blockSize]
    ]

    moveInto: field ifFail: aBlock [
	<category: 'moving'>
	(self canMoveInto: field) 
	    ifFalse: 
		[aBlock value.
		^false].
	self move.
	^true
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

    postCopy [
	<category: 'basic'>
	rotation := 1.
	origin := Point new.
	blocks := Array 
		    with: Point new
		    with: Point new
		    with: Point new
		    with: Point new
    ]
]

GtkMainWindow subclass: Tetris [
    | pause delay level grid movingBlocks statsWindow scoreLabel levelLabel linesLabel button canvas |
    
    <category: 'Graphics-Tetris'>
    <comment: nil>

    Tetris class >> open [
	<category: 'user interface'>

	TetrisPiece initialize.

	^ super open
	    play;
	    yourself
    ]

    initialize [
	<category: 'initialization'>

	super initialize.
	self 
	    title: 'Tetris';
	    createMenus;
	    createToolbar;
	    createStatusBar;
	    centralWidget: self buildCentralWidget
    ]

    postInitialize [
	<category: 'initialization'>

	window
	    connectSignal: 'key-press-event' to: self selector: #'keyPressedOn:keyEvent:' userData: nil
    ]

    createGameMenus [
        <category: 'user interface'>

        ^ self createNewMenuEntry: {}
    ]

    createHelpMenus [
        <category: 'user interface'>

        ^ self createNewMenuEntry: {GTK.GtkMenuItem menuItem: 'About Tetris' connectTo: self selector: #aboutLauncher.
            GTK.GtkMenuItem menuItem: 'About GNU Smalltalk' connectTo: self selector: #aboutGst}
    ]

    createMenus [
        <category: 'user interface'>

        self createMainMenu: {#('Game' #createGameMenus).
            #('Help' #createHelpMenus)}
    ]

    createToolbar [
        <category: 'user interface'>

        self
            appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-new');
            appendSeparator;
            appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-save');
            appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-save-as');
            appendSeparator;
            appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-cut');
            appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-copy');
            appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-paste');
            appendSeparator;
            appendToolItem: (GTK.GtkToolButton newFromStock: 'gtk-execute')
    ]

    createStatusBar [
        <category: 'user interface'>

        self statusMessage: 'GST-Tetris'
    ]

    buildCentralWidget [
	<category: 'user interface'>
	
	^ GTK.GtkDrawingArea new
	    connectSignal: 'expose_event' to: self selector: #'expose:event:' userData: nil;
	    yourself
    ]

    clearArea: aGtkAllocation on: aCairoContext [
        <category: 'drawing'>

        | res |
        res := aGtkAllocation castTo: (CIntType arrayType: 4).

        Cairo.Cairo
            rectangle: aCairoContext x: (res at: 0) y: (res at: 1) width: (res at: 2) height: (res at: 3);
            setOperator: aCairoContext operator: Cairo.Cairo operatorClear;
            fill: aCairoContext;
            setOperator: aCairoContext operator: Cairo.Cairo operatorOver
    ]

    expose: aGtkWidget event: aGdkEventExpose [
	<category: 'drawing event'>
        | context cr |

        cr := (GTK.Gdk cairoCreate: aGtkWidget getWindow).
        context := Cairo.CairoContext context: cr.

        self
            clearArea: aGtkWidget getAllocation on: cr.

        ^ true
    ]

    keyPressedOn: aGtkWidget keyEvent: aGdkEventKey [
	<category: 'key event'>

	'ici' printNl.
    ]

    cycle [
	<category: 'game'>
	| filledLines |
	grid := TetrisField new.
	grid nextPiece: TetrisPiece random.
	
	[grid currentPiece: grid nextPiece.
	grid nextPiece: TetrisPiece random.
	movingBlocks do: [:each | "each color: grid currentPiece color"].

	"If the piece cannot move, game over!"
	grid slidePiece] 
		whileTrue: 
		    [
		    ["window exists ifFalse: [^self]."
		    grid currentPiece drawWith: movingBlocks.
		    grid slidePiece] 
			    whileTrue: ["self delay"].
		    grid currentPiece cementOn: grid" drawOn: canvas".
		    self resetMovingBlocks.
		    filledLines := grid removeLines.
		    filledLines > 0 ifTrue: [self lines: self lines + filledLines].
		    Processor yield.
		    "(self lines - 1) // 10 > self level ifTrue: [self level: self level + 1]."
		    "self 
			score: 2 * self level squared + (#(0 50 150 400 900) at: filledLines + 1) 
				+ self score"].
	^self
    ]

    play [
	<category: 'game'>
	"button label: 'Pause'.
	button callback: self message: #pause."
	[ self
	    score: 0;
	    level: 1;
	    lines: 0;
	    resetCanvas;
	    cycle ] forkAt: Processor lowestPriority.
	"button callback: self message: #play"
    ]

    delay [
	"I like this method a lot!"

	<category: 'private'>
	delay wait.

	"Especially this semaphore!!"
	pause wait.
	pause signal
    ]

    level [
	<category: 'private'>
	^levelLabel label asInteger
    ]

    level: nextLevel [
	<category: 'private'>
	| level |
	level := nextLevel min: 10.
	delay := Delay forMilliseconds: 825 - (75 * level).
	"levelLabel label: level printString"
    ]

    lines [
	<category: 'private'>
	"^linesLabel label asInteger"
    ]

    lines: newLines [
	<category: 'private'>
	"linesLabel label: newLines printString"
    ]

    score [
	<category: 'private'>
	"^scoreLabel label asInteger"
    ]

    score: newScore [
	<category: 'private'>
	"scoreLabel label: newScore printString"
    ]

    advanceLevel [
	<category: 'events'>
	"self level: self level + 1"
    ]

    destroyed [
	<category: 'events'>
	"statsWindow exists ifTrue: [statsWindow destroy].
	window exists ifTrue: [window destroy]."
	^true
    ]

    movePieceLeft [
	<category: 'events'>
	^grid movePieceLeft
    ]

    movePieceRight [
	<category: 'events'>
	^grid movePieceRight
    ]

    pause [
	<category: 'events'>
	button label: 'Restart'.
	button callback: self message: #restart.

	"I like this semaphore a lot!"
	pause wait
    ]

    restart [
	<category: 'events'>
	button label: 'Pause'.
	button callback: self message: #pause.
	self activate.

	"I like this semaphore a lot!"
	pause signal
    ]

    rotatePiece [
	<category: 'events'>
	^grid rotatePiece
    ]

    slidePiece [
	<category: 'events'>
	^grid slidePiece
    ]

    dropPiece [
	<category: 'events'>
	^grid dropPiece
    ]

    bindKeys: keys [
	<category: 'user interface'>
	keys 
	    with: #(#movePieceLeft #movePieceRight #rotatePiece #slidePiece #dropPiece)
	    do: 
		[:key :selector | 
		canvas 
		    onKeyEvent: key
		    send: selector
		    to: self]
    ]

    layout [
	<category: 'user interface'>
	pause := Semaphore forMutualExclusion.
	(window := BWindow new: 'GNU Tetris!') width: TetrisPiece blockSize * 10
	    height: TetrisPiece blockSize * 22.
	(canvas := BCanvas new: window) 
	    x: TetrisPiece blockSize * -3
	    y: TetrisPiece blockSize * -3
	    width: TetrisPiece blockSize * 14
	    height: TetrisPiece blockSize * 28.
	window map.
	(statsWindow := BTransientWindow new: 'Scoring' in: window) 
	    x: window x + window width + 10
	    y: window y
	    width: 100
	    height: 150.
	(BLabel new: statsWindow label: 'Score') 
	    x: 0
	    y: 0
	    width: 100
	    height: 16.
	(BLabel new: statsWindow label: 'Lines') 
	    x: 0
	    y: 33
	    width: 100
	    height: 16.
	(BLabel new: statsWindow label: 'Level') 
	    x: 0
	    y: 66
	    width: 100
	    height: 16.
	(scoreLabel := BLabel new: statsWindow label: '0') 
	    x: 0
	    y: 17
	    width: 100
	    height: 16.
	(linesLabel := BLabel new: statsWindow label: '0') 
	    x: 0
	    y: 50
	    width: 100
	    height: 16.
	(levelLabel := BLabel new: statsWindow label: '0') 
	    x: 0
	    y: 83
	    width: 100
	    height: 16.
	(button := BButton new: statsWindow label: 'Start')
	    x: 0
		y: 100
		width: 100
		height: 23;
	    callback: self message: #play.
	(BButton new: statsWindow label: 'Next level')
	    x: 0
		y: 127
		width: 100
		height: 23;
	    callback: self message: #advanceLevel.
	statsWindow bringToTop.
	statsWindow callback: self message: #destroyed.
	window bringToTop.
	window callback: self message: #destroyed
    ]

    resetCanvas [
	<category: 'user interface'>
	"canvas empty."
	movingBlocks := Array 
		    with: nil "(BRectangle new: canvas)"
		    with: nil "(BRectangle new: canvas)"
		    with: nil "(BRectangle new: canvas)"
		    with: nil "(BRectangle new: canvas)".
	self resetMovingBlocks.
	movingBlocks do: [:each | "each create" ]
    ]

    resetMovingBlocks [
	<category: 'user interface'>
	movingBlocks 
	    do: [:each | "each origin: -50 @ -50 extent: TetrisPiece blockSize asPoint" ]
    ]
]


"Namespace current: GTK [
VisualGST.TetrisPiece initialize.
VisualGST.Tetris open
]"

