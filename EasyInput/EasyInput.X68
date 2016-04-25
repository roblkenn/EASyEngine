*--------------------------------------------------
* Title      : EasyInput v1.0
* Written by : Robert Kennedy
* Date       : 2016
* Description: Library used to handle user input.
*--------------------------------------------------
CODE    EQU     0
DATA    EQU     1

        SECTION     DATA
        ORG         $2000
        SECTION     CODE
        ORG         $1000
        
getKeyInput MACRO
    SECTION     DATA
KEYS\@      DC.B    '\1',0
    SECTION     CODE
    MOVEM.L     D0/A1,-(SP)
    MOVE.B      #0,D0
    LEA         KEYS\@,A1
    MOVE.B      (A1)+,D1
    WHILE.B (A1) <NE> #0 AND D0 <LT> #4 DO
        LSL.L   #8,D1        
        ADD.B   (A1)+,D1
        ADD.B   #1,D0
    ENDW
    MOVE.B  #19,D0
    TRAP    #15
    MOVEM.L     (SP)+,D0/A1
    ENDM
    
ifKey1      MACRO
    BTST.L  #24,D1
    IF <NE> THEN
    ENDM
    
ifKey2      MACRO
    BTST.L  #16,D1
    IF <NE> THEN
    ENDM
    
ifKey3      MACRO
    BTST.L  #8,D1
    IF <NE> THEN
    ENDM
    
ifKey4      MACRO
    BTST.L  #0,D1
    IF <NE> THEN
    ENDM
    
endIfKey    MACRO
    ENDI
    ENDM



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
