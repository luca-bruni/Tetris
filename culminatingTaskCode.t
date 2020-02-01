%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PROGRAM BY LUCA BRUNI%
%GRADE 10 CULMINATING TASK, COMPUTER SCIENCE%
%Date: 1/29/2016%
%Tetris Game re-make%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
setscreen ("graphics:270;440") %Sets screen size
View.Set ("offscreenonly") %Reduces flickering;Updates visuals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%
%Variables%
%%%%%%%%%%%

%Score
var score1 : int := 0 %Sets game score to 0 unless otherwise called for

%Mouse
var x, y, button : int %Finds mouse and detects clicking

%Colour
var colourz : int %Integer value can be set to assign colours

%Game over 
var die : boolean := false %False until game is lost

%counter
var ctr : int := 0 %Separates movement delay from fixed delay

%keyboard interaction
var chars : array char of boolean %Variable set for keyboard keys

%fonts
var font1 := Font.New ("serif:50") %Largest
var font2 := Font.New ("serif:20") %Large
var font3 := Font.New ("serif:10") %Small
var font4 := Font.New ("serif:18") %Medium

%%%%%%%%
%Arrays%
%%%%%%%%

%1 = very left, 2 = up, 3 = down, 4 = right
var squareX : array 1 .. 4 of int %X location of individual cube of piece
var squareY : array 1 .. 4 of int %Y location of individual cube of piece

var Map : array 0 .. 11, 0 .. 22 of int %Map array

procedure initArray %Initializes the array
    for map1 : 1 .. 10
	for map2 : 1 .. 22
	    Map (map1, map2) := 0
	end for
    end for
end initArray

%Map% %Height is 440 Width is 270

procedure mapDraw %Draws map based on array
    for i : 1 .. 10
	for u : 1 .. 20
	    drawfillbox (45 + i * 15, 60 + u * 15, 60 + i * 15, 45 + u * 15, Map (i, u))
	    drawbox (45 + i * 15, 60 + u * 15, 60 + i * 15, 45 + u * 15, black)
	end for
    end for

    for x : 0 .. 1
	for y : 1 .. 22
	    Map (11 * x, y) := 1
	end for
    end for

    for x1 : 0 .. 11
	Map (x1, 0) := 1
    end for
end mapDraw

%Rotating
var rotate : int := 1 %Gives each rotation (up to 4) a value

%%%%%%%%
%Shapes%
%%%%%%%%

%SquareX/Y 1..4 - used to make single cubes of each piece, at set positions. Values change from ctr, rotation, and chars.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Purple "T" piece%
procedure purplePiece
    squareX (1) := 105
    squareY (1) := 360
    squareX (2) := 120
    squareY (2) := 360
    squareX (3) := 120
    squareY (3) := 345
    squareX (4) := 135
    squareY (4) := 360
end purplePiece
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Blue "I" piece%
procedure bluelongPiece
    squareX (1) := 105
    squareY (1) := 360
    squareX (2) := 120
    squareY (2) := 360
    squareX (3) := 135
    squareY (3) := 360
    squareX (4) := 150
    squareY (4) := 360
end bluelongPiece
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Yellow "Box" piece%
procedure yellowPiece
    squareX (1) := 105
    squareY (1) := 360
    squareX (2) := 105
    squareY (2) := 345
    squareX (3) := 120
    squareY (3) := 345
    squareX (4) := 120
    squareY (4) := 360
end yellowPiece
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Orange "L" piece%
procedure orangePiece
    squareX (1) := 105
    squareY (1) := 360
    squareX (2) := 120
    squareY (2) := 360
    squareX (3) := 105
    squareY (3) := 345
    squareX (4) := 135
    squareY (4) := 360
end orangePiece
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Blue "inverted L" piece%
procedure bluePiece
    squareX (1) := 105
    squareY (1) := 360
    squareX (2) := 120
    squareY (2) := 360
    squareX (3) := 135
    squareY (3) := 345
    squareX (4) := 135
    squareY (4) := 360
end bluePiece
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Green "inverted Z" piece%
procedure greenPiece
    squareX (1) := 105
    squareY (1) := 345
    squareX (3) := 120
    squareY (3) := 345
    squareX (2) := 120
    squareY (2) := 360
    squareX (4) := 135
    squareY (4) := 360
end greenPiece
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Red "Z" piece%
procedure redPiece
    squareX (1) := 105
    squareY (1) := 360
    squareX (2) := 120
    squareY (2) := 360
    squareX (3) := 120
    squareY (3) := 345
    squareX (4) := 135
    squareY (4) := 345
end redPiece

%PERSONAL REFERENCE: Colours red= 40 orange= 42 purple= 5 bluelong= 53 blue= 32 yellow= 43 green= 2

%Choosing each piece at the end of a turn
var declarePiece : int := Rand.Int (1, 7) %Chooses random number btwn. 1-7, mirroring pieces
procedure pieceChoose
    declarePiece := Rand.Int (1, 7)
    var drawPiece : boolean := false
    if drawPiece = false then
	if declarePiece = 1 then
	    purplePiece
	    colourz := 5
	elsif declarePiece = 2 then
	    bluelongPiece
	    colourz := 53
	elsif declarePiece = 3 then
	    yellowPiece
	    colourz := 43
	elsif declarePiece = 4 then
	    orangePiece
	    colourz := 42
	elsif declarePiece = 5 then
	    bluePiece
	    colourz := 32
	elsif declarePiece = 6 then
	    greenPiece
	    colourz := 2
	elsif declarePiece = 7 then
	    redPiece
	    colourz := 40
	end if
	drawPiece := true
    end if
end pieceChoose

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Rotating the pieces%

%PERSONAL REFERENCE - 1 left 2 high 3 bottom 4 right
procedure purpleRotate
    if rotate = 1 then
	squareX (1) := squareX (1) - 15
	squareY (1) := squareY (1)
	squareX (2) := squareX (2)
	squareY (2) := squareY (2) - 15
	squareX (3) := squareX (3)
	squareY (3) := squareY (3)
	squareX (4) := squareX (4)
	squareY (4) := squareY (4)
    elsif rotate = 2 then
	squareX (1) := squareX (1)
	squareY (1) := squareY (1)
	squareX (2) := squareX (2)
	squareY (2) := squareY (2) + 15
	squareX (3) := squareX (3)
	squareY (3) := squareY (3)
	squareX (4) := squareX (4) - 15
	squareY (4) := squareY (4)
    elsif rotate = 3 then
	squareX (1) := squareX (1)
	squareY (1) := squareY (1)
	squareX (2) := squareX (2)
	squareY (2) := squareY (2)
	squareX (3) := squareX (3)
	squareY (3) := squareY (3) + 15
	squareX (4) := squareX (4) + 15
	squareY (4) := squareY (4)
    elsif rotate = 4 then
	squareX (1) := squareX (1) + 15
	squareY (1) := squareY (1)
	squareX (2) := squareX (2)
	squareY (2) := squareY (2)
	squareX (3) := squareX (3)
	squareY (3) := squareY (3) - 15
	squareX (4) := squareX (4)
	squareY (4) := squareY (4)
    end if
end purpleRotate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure bluelongRotate
    if rotate = 1 or rotate = 3 then
	squareX (1) := squareX (1) - 15
	squareY (1) := squareY (1)
	squareX (2) := squareX (2)
	squareY (2) := squareY (2) - 15
	squareX (3) := squareX (3) + 15
	squareY (3) := squareY (3) + 30
	squareX (4) := squareX (4) + 30
	squareY (4) := squareY (4) + 15
    elsif rotate = 2 or rotate = 4 then
	squareX (1) := squareX (1) + 15
	squareY (1) := squareY (1)
	squareX (2) := squareX (2)
	squareY (2) := squareY (2) + 15
	squareX (3) := squareX (3) - 15
	squareY (3) := squareY (3) - 30
	squareX (4) := squareX (4) - 30
	squareY (4) := squareY (4) - 15
    end if
end bluelongRotate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure orangeRotate
    if rotate = 1 then
	squareX (1) := squareX (1) %left
	squareY (1) := squareY (1) + 15
	squareX (2) := squareX (2) + 15 %high
	squareY (2) := squareY (2)
	squareX (3) := squareX (3) % bottom
	squareY (3) := squareY (3) + 15
	squareX (4) := squareX (4) + 15 %right
	squareY (4) := squareY (4) + 30
    elsif rotate = 2 then
	squareX (1) := squareX (1) + 15
	squareY (1) := squareY (1)
	squareX (2) := squareX (2) + 15
	squareY (2) := squareY (2)
	squareX (3) := squareX (3) + 30
	squareY (3) := squareY (3) - 15
	squareX (4) := squareX (4)
	squareY (4) := squareY (4) - 15
    elsif rotate = 3 then
	squareX (1) := squareX (1) - 15
	squareY (1) := squareY (1) - 15
	squareX (2) := squareX (2)
	squareY (2) := squareY (2)
	squareX (3) := squareX (3) - 15
	squareY (3) := squareY (3) + 15
	squareX (4) := squareX (4)
	squareY (4) := squareY (4)
    elsif rotate = 4 then
	squareX (1) := squareX (1)
	squareY (1) := squareY (1)
	squareX (2) := squareX (2) - 30
	squareY (2) := squareY (2)
	squareX (3) := squareX (3) - 15
	squareY (3) := squareY (3) - 15
	squareX (4) := squareX (4) - 15
	squareY (4) := squareY (4) - 15
    end if
end orangeRotate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure blueRotate
    if rotate = 1 then
	squareX (1) := squareX (1)
	squareY (1) := squareY (1) + 15
	squareX (2) := squareX (2) + 15
	squareY (2) := squareY (2)
	squareX (3) := squareX (3) + 30
	squareY (3) := squareY (3) + 15
	squareX (4) := squareX (4) + 15
	squareY (4) := squareY (4)
    elsif rotate = 2 then
	squareX (1) := squareX (1) + 15
	squareY (1) := squareY (1) - 30
	squareX (2) := squareX (2) + 15
	squareY (2) := squareY (2) - 15
	squareX (3) := squareX (3)
	squareY (3) := squareY (3) - 15
	squareX (4) := squareX (4)
	squareY (4) := squareY (4)
    elsif rotate = 3 then
	squareX (1) := squareX (1) - 15
	squareY (1) := squareY (1) + 15
	squareX (2) := squareX (2) - 30
	squareY (2) := squareY (2) + 15
	squareX (3) := squareX (3) - 15
	squareY (3) := squareY (3) + 15
	squareX (4) := squareX (4)
	squareY (4) := squareY (4) - 15
    elsif rotate = 4 then
	squareX (1) := squareX (1)
	squareY (1) := squareY (1)
	squareX (2) := squareX (2)
	squareY (2) := squareY (2)
	squareX (3) := squareX (3) - 15
	squareY (3) := squareY (3) - 15
	squareX (4) := squareX (4) - 15
	squareY (4) := squareY (4) + 15
    end if
end blueRotate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure redRotate
    if rotate = 1 or rotate = 3 then
	squareX (1) := squareX (1) - 15
	squareY (1) := squareY (1) + 15
	squareX (2) := squareX (2) - 15
	squareY (2) := squareY (2)
	squareX (3) := squareX (3)
	squareY (3) := squareY (3) + 15
	squareX (4) := squareX (4)
	squareY (4) := squareY (4)
    elsif rotate = 2 or rotate = 4 then
	squareX (1) := squareX (1) + 15
	squareY (1) := squareY (1) - 15
	squareX (2) := squareX (2) + 15
	squareY (2) := squareY (2)
	squareX (3) := squareX (3)
	squareY (3) := squareY (3) - 15
	squareX (4) := squareX (4)
	squareY (4) := squareY (4)
    end if
end redRotate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure greenRotate
    %1 left 2 high 3 bottom 4 right
    if rotate = 1 or rotate = 3 then
	squareX (1) := squareX (1)
	squareY (1) := squareY (1)
	squareX (3) := squareX (3)
	squareY (3) := squareY (3) + 15
	squareX (2) := squareX (2) + 15
	squareY (2) := squareY (2)
	squareX (4) := squareX (4) + 15
	squareY (4) := squareY (4) + 15
    elsif rotate = 2 or rotate = 4 then
	squareX (1) := squareX (1)
	squareY (1) := squareY (1)
	squareX (3) := squareX (3)
	squareY (3) := squareY (3) - 15
	squareX (2) := squareX (2) - 15
	squareY (2) := squareY (2)
	squareX (4) := squareX (4) - 15
	squareY (4) := squareY (4) - 15
    end if
end greenRotate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

procedure rotatePiece %Calls on the appropriate procedures at which to rotate the piece
    if declarePiece = 1 then
	purpleRotate
    elsif declarePiece = 2 then
	bluelongRotate
    elsif declarePiece = 4 then
	orangeRotate
    elsif declarePiece = 5 then
	blueRotate
    elsif declarePiece = 6 then
	greenRotate
    elsif declarePiece = 7 then
	redRotate
    end if
end rotatePiece

%Re-choosing a piece at the end of a turn
procedure firstLine %Chooses a new piece when one stops
    for u : 1 .. 4
	if squareY (3) <= 45| Map (squareX (u) div 15 - 3, squareY (u) div 15 - 3) not= 0 then
	    for i : 1 .. 4
		Map (squareX (i) div 15 - 3, squareY (i) div 15 - 2) := colourz
	    end for
	    delay (400)
	    pieceChoose
	    rotate := 1            
	end if
    end for
end firstLine

%Movements (Side-to-side, down, diagonal)
procedure sideMoving %Uses A,D,S,SPACE, to move left, right, down, diagonal, and rotate from keyboard
    Input.KeyDown (chars)
    if chars ('a') & Map (squareX (1) div 15 - 4, squareY (1) div 15 - 2) = 0 then
	for a : 1 .. 4
	    squareX (a) := squareX (a) - 15
	end for
    end if
    if chars ('d') & Map (squareX (4) div 15 - 2, squareY (4) div 15 - 2) = 0 then
	for d : 1 .. 4
	    squareX (d) := squareX (d) + 15
	end for
    end if
    if chars ('s') & Map (squareX (3) div 15 - 3, squareY (3) div 15 - 3) = 0 then
	for s : 1 .. 4
	    squareY (s) := squareY (s) - 15
	end for
    end if
    if chars (' ') = true then
	rotate := rotate + 1
	if rotate > 4 then
	    rotate := 1
	end if
	rotatePiece
    end if
    delay (70)
end sideMoving

%Counting system to avoid delays with movement
procedure timectr %Counter works with delay and acts as its own
    ctr := ctr + 1
    if ctr = 8 then
	for i : 1 .. 4
	    squareY (i) := squareY (i) - 15
	end for
	ctr := 0
    end if
end timectr

%Checking location of each piece (for line-making and falling pieces)
procedure pieceCheck %Checks map array if a line has all values above 0 and if so, clears a line
    var counter : int := 0
    for u : 1 .. 20
	for i : 1 .. 10
	    if Map (i, u) not= 0 then
		counter := counter + 1
	    end if
	end for
	if counter = 10 then
	    for z : 1 .. 10
		Map (z, u) := 0
	    end for
	    for y : u .. 20
		for x : 1 .. 10
		    Map (x, y) := Map (x, y + 1)
		end for
	    end for
	    score1 := score1 + 1
	end if
	counter := 0
    end for
end pieceCheck

%ENDING GAME
procedure endGame %Ends the game if a piece reaches the Y limit
    for i : 1 .. 10
	if Map (i, 21) not= 0 then
	    die := true
	end if
    end for
end endGame

%Score
procedure scores %Draws the score at the bottom
    Font.Draw (intstr (score1), 160, 25, font2, black)
end scores

%Music
procedure music %Plays tetris theme
    Music.PlayFileLoop ("Tetris.mp3")
end music

%Instructions
procedure instr %Gives instructions on how to play
    colour (black)
    put "- There are 7 types of blocks"
    put "- Use blocks to make lines"
    put "- Visis 'controls' for help"
    put "- A line will disappear once made"
    put "- All other pieces will go down"
    put "- 1 line made = 1 score"
end instr

%Controls
procedure controls %Shows controls and how to use them
    colour (black)
    put "- Press 'a' to move left"
    put "- Press 'd' to move right"
    put "- Press 's' to move down fast"
    put "- Use 'SPACE' to rotate piece"
end controls

%%%%%%%%%%%
%Game loop%
%%%%%%%%%%%
pieceChoose
procedure gameloop
    loop
	View.Set ("offscreenonly")
	colorback (66)
	cls
	Font.Draw ("TETRIS", 20, 380, font1, black)
	Font.Draw ("Score:", 85, 25, font2, black)

	mapDraw
	pieceCheck
	endGame
	scores
	timectr
	sideMoving
	firstLine

	exit when die = true

	for i : 1 .. 4
	    drawfillbox (squareX (i), squareY (i), squareX (i) + 15, squareY (i) + 15, colourz)
	    drawbox (squareX (i), squareY (i), squareX (i) + 15, squareY (i) + 15, black)
	end for
	View.Update
    end loop
end gameloop

%Lobby system
var pic := Pic.FileNew ("tetrispic.jpg")
procedure lobby %The game menu
    loop
	colourback (103)
	cls
	mousewhere (x, y, button)
	drawfillbox (35, 50, 85, 75, black)
	drawfillbox (32, 53, 88, 72, black)
	Font.Draw ("Start", 47, 59, font3, white)
	drawfillbox (110, 50, 160, 75, black)
	drawfillbox (107, 53, 163, 72, black)
	Font.Draw ("Instr.", 120, 59, font3, white)
	drawfillbox (185, 50, 235, 75, black)
	drawfillbox (182, 53, 238, 72, black)
	Font.Draw ("Contr.", 195, 59, font3, white)
	Font.Draw ("Welcome to Tetris!", 40, 150, font4, black)
	Font.Draw ("Re-make by Luca Bruni.", 20, 120, font4, black)
	if x > 35 and x < 85 and y > 50 and y < 75 and button = 1 then
	    music
	    gameloop
	elsif x > 35 and x < 85 and y > 50 and y < 75 then
	    drawfillbox (35, 50, 85, 75, white)
	    Font.Draw ("Start", 47, 59, font3, black)
	end if

	if x > 110 and x < 160 and y > 50 and y < 75 and button = 1 then
	    instr
	elsif x > 110 and x < 160 and y > 50 and y < 75 then
	    drawfillbox (110, 50, 160, 75, white)
	    Font.Draw ("Instr.", 120, 59, font3, black)
	end if

	if x > 185 and x < 235 and y > 50 and y < 75 and button = 1 then
	    controls
	elsif x > 185 and x < 235 and y > 50 and y < 75 then
	    drawfillbox (185, 50, 235, 75, white)
	    Font.Draw ("Contr.", 195, 59, font3, black)
	end if
	
	Pic.Draw (pic, 35, 200, picCopy)
	exit when die = true
	View.Update
	cls
    end loop
    
end lobby

loop %When the game ends
    cls
    initArray
    lobby
    colorback (black)
    cls
    Pic.Draw (pic, 35, 200, picCopy)
    Font.Draw ("GAME OVER!", 60, 150, font4, white)
    Font.Draw ("Score: ", 80, 120, font4, white)
    Font.Draw (intstr (score1), 155, 120, font4, white)
    View.Update
    delay (5000)
    die := false
    score1 := 0
end loop

%PERSONAL REFERENCE: colours red= 40 orange= 42 purple= 5 bluelong= 53 blue= 32 yellow= 44 green= 2





