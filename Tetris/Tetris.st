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

GtkMainWindow subclass: Tetris [
    | canvasWidget canvas pause delay grid movingBlocks level statsWindow scoreLabel levelLabel linesLabel button |
    
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
	movingBlocks := false.
	self 
	    title: 'Tetris';
	    createMenus;
	    createToolbar;
	    createStatusBar;
	    centralWidget: self buildCentralWidget
    ]

    postInitialize [
	<category: 'initialization'>

	canvasWidget grabFocus.
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
	
	^ canvasWidget := GTK.GtkDrawingArea new
	    setSizeRequest: 400 height: 700;
	    connectSignal: 'expose_event' to: self selector: #'expose:event:' userData: nil;
	    yourself
    ]

    clearArea: aGtkAllocation on: aCairoContext [
        <category: 'drawing'>

        | res |
        res := aGtkAllocation castTo: (CIntType arrayType: 4).

        Cairo.Cairo
            rectangle: aCairoContext x: 0 y: 0 width: (res at: 2) height: (res at: 3);
            setOperator: aCairoContext operator: Cairo.Cairo operatorClear;
            fill: aCairoContext;
            setOperator: aCairoContext operator: Cairo.Cairo operatorOver
    ]

    drawArea [
	<category: 'drawing'>

	1 to: 22 do: [ :i |
	    BlockWidget new
		position: 50@(50 + ((i - 1) * 15));
		size: 15;
		drawOn: canvas.

            BlockWidget new
                position: (50 + (11 * 15))@(50 + ((i - 1) * 15));
                size: 15;
                drawOn: canvas ].

	1 to: 12 do: [ :i |
            BlockWidget new
                position: (50 + ((i - 1) * 15))@50;
                size: 15;
                drawOn: canvas.

            BlockWidget new
                position: (50 + ((i - 1) * 15))@(50 + (22 * 15));
                size: 15;
                drawOn: canvas ]
    ]

    drawGrid [
	<category: 'drawing'>

	grid ifNil: [ ^ self ].
	grid drawOn: canvas
    ]

    expose: aGtkWidget event: aGdkEventExpose [
	<category: 'drawing event'>
        | cr |

        cr := (GTK.Gdk cairoCreate: aGtkWidget getWindow).
        canvas := Cairo.CairoContext context: cr.

        self
            clearArea: aGtkWidget getAllocation on: cr;
	    drawArea;
	    drawGrid.

        ^ true
    ]

    keyPressedOn: aGtkWidget keyEvent: aGdkEventKey [
	<category: 'key event'>

	| event |
	movingBlocks ifFalse: [ ^ false ].

	event := aGdkEventKey castTo: GTK.GdkEventKey type.

	event keyval value = 65361 ifTrue: [ self movePieceLeft. ^ true ].
	event keyval value = 65363 ifTrue: [ self movePieceRight. ^ true ].
	event keyval value = 65362 ifTrue: [ self rotatePiece. ^ true ].
	event keyval value = 65364 ifTrue: [ self dropPiece. ^ true ].

	^ false
    ]

    refresh [
	<category: 'drawing'>

	canvasWidget queueDraw
    ]

    cycle [
	<category: 'game'>
	
	| result filledLines |
	grid := TetrisField new.
	[ movingBlocks := true.
	  result := grid currentPiece: TetrisPiece random.
	  result ifTrue: [ self 
			    refresh;
			    delay ].
	  result ] whileTrue: [ 
		[ result := self slidePiece.
		  self refresh.
		  result ] whileTrue: [ self delay ].
		  filledLines := self 
				    resetMovingBlocks;
				    cementPiece;
				    removeLines.
		  Processor yield ].

	"[ 
	 grid currentPiece: TetrisPiece random.
	 self 
	    slidePiece;
	    refresh ] whileTrue: [
		    [ grid currentPiece drawWith: movingBlocks.
		     grid slidePiece ] whileTrue: [self delay].
		    grid currentPiece cementOn: grid drawOn: canvas.
		    self resetMovingBlocks.
		    filledLines := grid removeLines.
		    filledLines > 0 ifTrue: [self lines: self lines + filledLines].
		    Processor yield.
		    (self lines - 1) // 10 > self level ifTrue: [self level: self level + 1].
		    self 
			score: 2 * self level squared + (#(0 50 150 400 900) at: filledLines + 1) 
				+ self score]."
	^ self
    ]

    initializeGame [
	<category: 'game'>

	self level: 1.
	movingBlocks := true
    ]

    play [
	<category: 'game'>

	[ self
	    initializeGame;
	    cycle ] fork"At: Processor lowestPriority".
	Processor activeProcess suspend
    ]

    resetMovingBlocks [
	<category: 'game'>

	movingBlocks := false
    ]

    delay [
	"I like this method a lot!"

	<category: 'private'>
	delay wait.

	"Especially this semaphore!!
	pause wait.
	pause signal"
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

    movePieceLeft [
	<category: 'events'>

	^ grid movePieceLeft
    ]

    movePieceRight [
	<category: 'events'>

	^ grid movePieceRight
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

	^ grid rotatePiece
    ]

    slidePiece [
	<category: 'events'>

	^ grid slidePiece
    ]

    cementPiece [
	<category: 'events'>

	^ grid cementPiece
    ]

    removeLines [
	<category: 'game'>

	^ grid removeLines
    ]

    dropPiece [
	<category: 'events'>
	^grid dropPiece
    ]
]

