*---------------------------------------------------
* Title      : EasySound v1.0
* Written by : Robert Kennedy
* Date       : 2016
* Description: Library to handle sound operations.
*---------------------------------------------------

dxEnabled   dc.b    1

loadSound  
    MOVEM.L     D0,-(SP) 
    IF.B dxEnabled <EQ> #1 THEN
        MOVE.B  #74,D0
        TRAP    #15
        IF.W D0 <EQ> #0 THEN
            MOVE.B  #0,dxEnabled
            BSR     loadSoundNDX
        ENDI
    ELSE
        BSR     loadSoundNDX
    ENDI  
    MOVEM.L     (SP)+,D0
    RTS           
loadSoundNDX   
    MOVE.B      #71,D0
    TRAP        #15
    RTS

playSound
    MOVEM.L     D0,-(SP)
    IF.B dxEnabled <EQ> #1 THEN
        MOVE.B  #75,D0
        TRAP    #15
    ELSE
        BSR         playSoundNDX
    ENDI
    MOVEM.L     (SP)+,D0
    RTS    
playSoundNDX
    MOVE.B      #72,D0
    TRAP        #15
    RTS

loopSound
    MOVEM.L     D0/D2,-(SP)
    IF.B dxEnabled <EQ> #1 THEN
        MOVE.B  #77,D0
        MOVE.L  #1,D2
        TRAP    #15
    ELSE
        BSR     loopSoundNDX
    ENDI
    MOVEM.L     (SP)+,D0/D2
    RTS
loopSoundNDX
    MOVE.B      #76,D0
    MOVE.L      #1,D2
    TRAP        #15
    RTS
    
stopSound
    MOVEM.L     D0/D2,-(SP)
    IF.B dxEnabled <EQ> #1 THEN
        MOVE.B  #77,D0
        MOVE.L  #2,D2
        TRAP    #15
    ELSE
        BSR     stopSoundNDX
    ENDI
    MOVEM.L     (SP)+,D0/D2
    RTS
stopSoundNDX
    MOVE.B      #76,D0
    MOVE.L      #2,D2
    TRAP        #15
    RTS
    
stopAllSounds
    MOVEM.L     D0/D2,-(SP)
    IF.B dxEnabled <EQ> #1 THEN
        MOVE.B  #77,D0
        MOVE.L  #3,D2
        TRAP    #15
    ELSE
        BSR     stopAllSoundsNDX
    ENDI
    MOVEM.L     (SP)+,D0/D2
    RTS
stopAllSoundsNDX
    MOVE.B      #76,D0
    MOVE.L      #3,D2
    TRAP        #15
    RTS
    
    




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
