*--------------------------------------------------------------
* Title      : EasyInput testCase
* Written by : Robert Kennedy
* Date       : 2016
* Description: Testing the library used to handle user input.
*--------------------------------------------------------------

    INCLUDE 'EasyInput.x68'

    ORG    $1000
    
START:                  ; first instruction of program

    MOVE.B  #92,D0
    MOVE.B  #17,D1
    TRAP    #15

inputLoop
    getKeyInput <WASD>
    ifKey1
        LEA     str1,A1
        MOVE.B  #13,D0
        TRAP    #15
    endIfKey
    ifKey2
        LEA     str2,A1
        MOVE.B  #13,D0
        TRAP    #15
    endIfKey
    ifKey3
        LEA     str3,A1
        MOVE.B  #13,D0
        TRAP    #15
    endIfKey
    ifKey4
        LEA     str4,A1
        MOVE.B  #13,D0
        TRAP    #15
    endIfKey
    
    MOVE.B  #94,D0
    TRAP    #15
    
    MOVE.W  #$FF00,D1
    MOVE.B  #11,D0
    TRAP    #15
    
    BRA     inputLoop

    SIMHALT             ; halt simulator

str1    dc.b    'Key 1 Is Being Pressed.',0
str2    dc.b    'Key 2 Is Being Pressed.',0
str3    dc.b    'Key 3 Is Being Pressed.',0
str4    dc.b    'Key 4 Is Being Pressed.',0

    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
