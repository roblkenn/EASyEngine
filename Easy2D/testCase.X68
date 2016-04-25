*------------------------------------------------------------------------------
* Title      : Easy2D testCase
* Written by : Robert Kennedy
* Date       : 2016
* Description: Tests the Easy2D library.
*------------------------------------------------------------------------------

    ORG    $1000
START:                  ; first instruction of program

; Initalize Easy2D
    MOVE.W  #8,D0            ; Set scale to 8x
    JSR     initializeEasy2D ; Use default image mask of $00FF00FF

; Load sonic.bmp image from file into memory
    LEA     sonic_filename,A1    ; Put filename string in A1
    JSR     loadImage            ; Load image into memory
    MOVE.L  A1,sonic_image       ; Store returned address of image data
    
; Load sonicRun.bmp image from file into memory
    LEA     sonicRun_filename,A1 ; Put filename string in A1 
    JSR     loadImage            ; Load image into memory
    MOVE.L  A1,sonicRun_Image    ; Store returned addres of image data

; Set image properties and draw to buffer
    MOVE.L  sonic_image,A1  ; Point to sonic image
    MOVE.W  #0,D4           ; Set x origin
    MOVE.W  #0,D5           ; Set y origin
    JSR     displayImage    ; draws image to the back buffer
    
    MOVE.L  sonicRun_image,A1 ; Point to sonicRun image
    MOVE.W  #28,D4            ; Set x origin
    MOVE.W  #0,D5             ; Set y origin
    JSR     displayImage      ; draws image to the back buffer
        
; Display back buffer containing images
    MOVE.B  #94,D0
    TRAP    #15


    SIMHALT             ; halt simulator

sonic_filename      DC.B    'sonic.bmp',0    ; Test image filename
sonic_image         DS.L    1                ; Sonic image data pointer
sonicRun_filename   DC.B    'sonicRun.bmp',0 ; Test image2 filename
sonicRun_image      DS.L    1                ; SonicRun image data pointer

    INCLUDE 'Easy2D.X68'    ; Include image handling library

    END    START        ; last line of source




















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
