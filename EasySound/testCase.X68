*-----------------------------------------------------------
* Title      : EasySound testCase
* Written by : Robert Kennedy
* Date       : 1/23/16
* Description: Test for the EasySound subroutine library.
*-----------------------------------------------------------

* Delay for hundredths of a second in param 1
DELAY    MACRO
    MOVEM.L D0/D1,-(SP)
    move.b  #23,d0          trap task 23
    move.l  #\1,d1          delay amount
    trap    #15
    MOVEM.L (SP)+,D0/D1
    ENDM

    ORG    $1000
START:                  ; first instruction of program
    
; Load music files into sound memory
    LEA     allofus,A1
    MOVE.B  #allofusID,D1
    JSR     loadSound
    
    LEA     ascending,A1
    MOVE.B  #ascendingID,D1
    JSR     loadSound
    
    LEA     digital,A1
    MOVE.B  #digitalID,D1
    JSR     loadSound
    
    LEA     searching,A1
    MOVE.B  #searchingID,D1
    JSR     loadSound
; Load music end

; Play each song for 10 seconds    
    MOVE.B  #allofusID,D1
    JSR     playSound
    DELAY   1000
    JSR     stopSound
    
    MOVE.B  #ascendingID,D1
    JSR     playSound
    DELAY   1000
    JSR     stopSound
    
    MOVE.B  #digitalID,D1
    JSR     playSound 
    DELAY   1000
    JSR     stopSound
; Play each finished

; Play multiple songs
    MOVE.B  #allofusID,D1
    JSR     playSound
    DELAY   200
    
    MOVE.B  #ascendingID,D1
    JSR     playSound
    DELAY   200
    
    MOVE.B  #digitalID,D1
    JSR     playSound
    DELAY   500
    
    JSR     stopAllSounds
; Play multiple songs end

; Loop final song
    MOVE.B  #searchingID,D1
    JSR     loopSound

    SIMHALT             ; halt simulator

allofus      dc.b    'allOfUs.wav',0
allofusID    equ     0
ascending    dc.b    'ascending.wav',0
ascendingID  equ     1
digital      dc.b    'digitalNative.wav',0
digitalID    equ     2
searching    dc.b    'searching.wav',0
searchingID  equ     3

    INCLUDE     'EasySound.X68'

    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
