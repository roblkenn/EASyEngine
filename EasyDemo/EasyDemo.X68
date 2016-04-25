*-----------------------------------------------------------
* Title      : EasyEngine Demo
* Written by : Robert Kennedy
* Date       : 4/20/16
* Description: This program demonstrates the capabilities of EasyEngine.
*-----------------------------------------------------------
    OPT MEX
    INCLUDE 'EasyInput.X68'
    ORG    $1000
START:                  ; first instruction of program

; Initialize Easy2D
    MOVE.W  #4,D0               ; Set image scale to 8 pixels per square.
    BSR     initializeEasy2D    ; Uses default color mask of $00FF00FF (magenta).
    
; Load image files into memory and store memory locations.
    LEA     sonicRFilename,A1
    BSR     loadImage
    MOVE.L  A1,sonicR
    
    LEA     sonicLFilename,A1
    BSR     loadImage
    MOVE.L  A1,sonicL
    
    LEA     sonicRunRFilename,A1
    BSR     loadImage
    MOVE.L  A1,sonicRunR
    
    LEA     sonicRunLFilename,A1
    BSR     loadImage
    MOVE.L  A1,sonicRunL
    
; Load sound files into audio memory.
    LEA     musicFilename,A1
    MOVE.B  #musicID,D1
    BSR     loadSound
    
; Start game music loop
    BSR     loopSound
    
; Main game loop
    REPEAT
    
    IF.B jumping <EQ> #0 THEN
        IF.W sonicY <LT> #82 THEN
            ADD.W   #2,sonicY
        ENDI
    ENDI
    
; Default sonic to standing image and set jump paramters
    MOVE.B  #0,running
    MOVE.B  #0,jumping
    IF.W sonicY <EQ> #82 THEN
        MOVE.B  #1,canJump
    ENDI
    
; Get user input and set sonic to running if any movement key is pressed.
    getKeyInput < ADQ>
    ifKey1
        ; Jump logic
        IF.B canJump <EQ> #1 THEN
            IF.W sonicY <GT> #40 THEN
                MOVE.B  #1,jumping
                SUB.W   #2,sonicY
            ELSE
                MOVE.B  #0,canJump
            ENDI
        ENDI
    endIfKey
    ifKey2
        ; Run left logic
        MOVE.B  #1,running
        MOVE.B  #0,facingR
        SUB.W   #2,sonicX
    endIfKey
    ifKey3
        ; Run right logic
        MOVE.B  #1,running
        MOVE.B  #1,facingR
        ADD.W   #2,sonicX
    endIfKey
    ifKey4
        ; Set quit trigger
        MOVE.B  #1,quit
    endIfKey
    
; Set image properties and draw to buffer
    IF.B running <EQ> #0 THEN
        IF.B facingR <EQ> #1 THEN
            MOVE.L  sonicR,A1   ; Point to the sonic standing right image
        ELSE
            MOVE.L  sonicL,A1   ; Point to the sonic standing left image
        ENDI
    ELSE
        IF.B facingR <EQ> #1 THEN
            MOVE.L  sonicRunR,A1    ; Point to the sonic running right image
        ELSE
            MOVE.L  sonicRunL,A1    ; Point to the sonic running left image
        ENDI
    ENDI
    MOVE.W  sonicX,D4           ; Set x origin
    MOVE.W  sonicY,D5           ; Set y origin
    BSR     displayImage        ; draws image to the back buffer
    
; Display back buffer
    MOVE.B  #94,D0
    TRAP    #15
    
; Clear new back buffer
    MOVE.W  #$FF00,D1
    MOVE.B  #11,D0
    TRAP    #15
    
    UNTIL.B quit <EQ> #1 DO
    
; Stops all sounds after ending the game.
    BSR     stopAllSounds
    
; Clear the back buffer after ending.
    MOVE.W  #$FF00,D1
    MOVE.B  #11,D0
    TRAP    #15
    
; Display the blank buffer to clear the screen.
    MOVE.B  #94,D0
    TRAP    #15

    SIMHALT             ; halt simulator


running        DC.B    0
canJump        DC.B    1
jumping        DC.B    0
facingR        DC.B    1
sonicX         DC.W    0
sonicY         DC.W    82

quit           DC.B    0

sonicR         DS.L    1
sonicL         DC.L    1
sonicRunR      DC.L    1
sonicRunL      DC.L    1

sonicRFilename      DC.B    'sonicR.bmp',0
sonicLFilename      DC.B    'sonicL.bmp',0
sonicRunRFilename   DC.B    'sonicRunR.bmp',0
sonicRunLFilename   DC.B    'sonicRunL.bmp',0
musicFilename       DC.B    'king.wav',0
musicID             EQU     0
musicOn             DC.B    1

    INCLUDE 'EasySound.X68'
    INCLUDE 'Easy2D.X68'

    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
