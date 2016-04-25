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
    LEA     mona,A1
    MOVE.B  #monaID,D1
    JSR     loadSound
    
    LEA     epona,A1
    MOVE.B  #eponaID,D1
    JSR     loadSound
    
    LEA     war,A1
    MOVE.B  #warID,D1
    JSR     loadSound
    
    LEA     king,A1
    MOVE.B  #kingID,D1
    JSR     loadSound
; Load music end

; Play each song for 10 seconds    
    MOVE.B  #monaID,D1
    JSR     playSound
    DELAY   1000
    JSR     stopSound
    
    MOVE.B  #eponaID,D1
    JSR     playSound
    DELAY   1000
    JSR     stopSound
    
    MOVE.B  #warID,D1
    JSR     playSound 
    DELAY   1000
    JSR     stopSound
; Play each finished

; Play multiple songs
    MOVE.B  #monaID,D1
    JSR     playSound
    DELAY   200
    
    MOVE.B  #eponaID,D1
    JSR     playSound
    DELAY   200
    
    MOVE.B  #warID,D1
    JSR     playSound
    DELAY   500
    
    JSR     stopAllSounds
; Play multiple songs end

; Loop final song
    MOVE.B  #kingID,D1
    JSR     loopSound

    SIMHALT             ; halt simulator

mona    dc.b    'inisMona.wav',0
monaID  equ     0
epona   dc.b    'aRoseForEpona.wav',0
eponaID equ     1
war     dc.b    'warOfTheGods.wav',0
warID   equ     2
king    dc.b    'king.wav',0
kingID  equ     3

    INCLUDE     'EasySound.X68'

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
