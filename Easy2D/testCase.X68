*------------------------------------------------------------------------------
* Title      : Easy2D testCase
* Written by : Robert Kennedy
* Date       : 2016
* Description: Tests the Easy2D library.
*------------------------------------------------------------------------------

    ORG    $1000
START:                  ; first instruction of program

; Initalize Easy2D
    MOVE.W  #4,D0               ; Set scale to 8x
    JSR     initializeEasy2D    ; Use default image mask of $00FF00FF

; Load dave.bmp image from file into memory
    LEA     dave_filename,A1    ; Put filename string in A1
    JSR     loadImage           ; Load image into memory
    MOVE.L  A1,dave_image       ; Store returned address of image data
    
; Load daveRun.bmp image from file into memory
    LEA     daveRun_filename,A1  ; Put filename string in A1 
    JSR     loadImage            ; Load image into memory
    MOVE.L  A1,daveRun_Image     ; Store returned addres of image data

; Set image properties and draw to buffer
    MOVE.L  dave_image,A1   ; Point to dave image
    MOVE.W  #0,D4           ; Set x origin
    MOVE.W  #0,D5           ; Set y origin
    JSR     displayImage    ; draws image to the back buffer
    
    MOVE.L  daveRun_image,A1  ; Point to daveRun image
    MOVE.W  #48,D4            ; Set x origin
    MOVE.W  #0,D5             ; Set y origin
    JSR     displayImage      ; draws image to the back buffer
        
; Display back buffer containing images
    MOVE.B  #94,D0
    TRAP    #15


    SIMHALT             ; halt simulator

dave_filename      DC.B    'dave.bmp',0     ; Test image filename
dave_image         DS.L    1                ; dave image data pointer
daveRun_filename   DC.B    'daveRun.bmp',0  ; Test image2 filename
daveRun_image      DS.L    1                ; daveRun image data pointer

    INCLUDE 'Easy2D.X68'    ; Include image handling library

    END    START        ; last line of source





















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
