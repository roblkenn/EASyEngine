*------------------------------------------------------------------------------
* Title      : Easy2D v1.0
* Written by : Robert Kennedy
* Date       : 2016
* Description: Library used to handle bitmap graphics, scaling, and rotation.
*------------------------------------------------------------------------------

*************************************************************************************
*
* Initializes Easy 2D and sets global parameters
* Parameters: D0.W - Image scale (Default: 0)
*             D1.L - Alpha mask  (Default: $00FF00FF)

initializeEasy2D
    MOVEM.L A1,-(SP)    
    LEA easy2d_settings,A1
    
    IF.W D0 <NE> #0 THEN
        MOVE.W  D0,easy2d_scale(A1)
    ELSE
        MOVE.W  #0,easy2d_scale(A1)
    ENDI
    
    IF.L D1 <NE> #0 THEN
        MOVE.L  D1,easy2d_mask(A1)
    ELSE
        MOVE.L  #$00FF00FF,easy2d_mask(A1)
    ENDI
    
    ; Enable double buffering
    MOVE.B  #17,D1
    MOVE.B  #92,D0
    TRAP    #15
    
    ; Clear screen
    MOVE.B  #11,D0
    MOVE.W  #$FF00,D1
    TRAP    #15


    MOVEM.L (SP)+,A1
    RTS
    

*************************************************************************************
*
* Load an image from file into memory and extract information
* Parameters: A1 - Null terminated filename string
* Returns: A1 - Memory address of the image data

loadImage
    MOVE.L   easy2d_endOfImages,A3    ; Point to image data
    
; Get file_id from filename sotred in A1
    MOVE.B  #51,D0
    TRAP    #15
    
    MOVE.L  D1,easy2d_fileID(A3)   ; Store fileID into memory.
    
; Load file into the image buffer
    LEA     easy2d_imFile(A3),A1   ; Point A1 to the file buffer
    MOVEQ   #$0E,D2         ; Set the byte count to load the file header
    MOVE.L  D2,D3           ; Copy the file header byte count
    MOVEQ   #53,D0          ; Read from the file
    TRAP    #15
    
    CMP.L   D3,D2           ; Compare the bytes read with the expected byte count
    BNE.S   easy2d_exitLoadFile    ; if incorrect do failure exit
    
    CMPI.W  #'BM',(A1)+     ; Compare the signature word with "BM"
    BNE.S   easy2d_exitLoadFile    ; if incorrect do failure exit
    
    NEG.L   D2              ; Negate the byte count so far
    BSR     easy2d_getLong         ; Get the file size
    ADD.L   D0,D2           ; Add the file size longword to give the remaining byte count
    MOVE.L  D2,easy2d_fileSize(A3) ; Store the filesize
    
    MOVE.L  D2,D3           ; Copy the remaining byte count
    ADDQ.W  #4,A1           ; Skip the two reserved words
    BSR     easy2d_getLong         ; Get the image start offset
    SUB.L   #$0E,D0         ; Subtract the file header size
    MOVE.L  D0,easy2d_imageStart(A3) ; Save the image start offset
    
    LEA     easy2d_imFile(A3),A1   ; Point to the file buffer
    MOVEQ   #53,D0          ; Read from the file
    TRAP    #15
    
    CMP.L   D3,D2           ; Compare the bytes read with the expected byte count
    BNE.S   easy2d_exitLoadFile    ; if incorrect do failure exit
    
; Load bm image header information
    MOVEQ   #$28,D2         ; Set the size that is expected
    BSR     easy2d_getLong         ; get the image header size
    CMP.L   D2,D0           ; Compare the bytes read with the expected byte count
    BNE.S   easy2d_finishLoad      ; If incorrect exit
    
    BSR     easy2d_getLong         ; get the image width
    MOVE.L  D0,easy2d_imWidth(A3)  ; store image width
    BSR     easy2d_getLong         ; get the image height
    MOVE.L  D0,easy2d_imHeight(A3) ; store image height
    
    BSR     easy2d_getWord         ; get the number of planes
    CMPI.W  #1,D0           ; compare with expected number
    BNE.S   easy2d_finishLoad      ; if incorrect exit
    
    BSR     easy2d_getWord         ; get the image depth
    MOVE.W  D0,easy2d_imDepth(A3)  ; store image depth
    
    BSR     easy2d_getLong         ; get the compression type
    MOVE.L  D0,D1           ; Flag success only if D0 is zero
    BNE.S   easy2d_finishLoad      ; if incorrect exit
    
    LEA     $14(A1),A1      ; skip the rest of the header

; Load palette information
    MOVE.W  easy2d_imDepth(A3),D0  ; Get the image depth
    CMPI.W  #24,D0          ; compare the image depth with 24bpp
    BLT.S   easy2d_exitLoadFile    ; if depth < 24bpp do failure exit
    BRA     easy2d_finishLoad      ; Return success
    
easy2d_exitLoadFile
    MOVEQ   #-1,D1          ; Flag load failed
    RTS
    
easy2d_finishLoad
    MOVE.L  A3,A1                       ; Return address of image
    
    ; Calculate the address to store the next image
    MOVE.L  easy2d_fileSize(A3),D1             ; move fileSize to D1 for math
    ADD.L   D1,easy2d_endOfImages              ; add filesize to end of images
    ADD.L   #$1C,easy2d_endOfImages            ; add bm header size to end of images  
    
    ; Clear registers of junk
    MOVE.L  #0,A3
    CLR.L   D0
    CLR.L   D2
    CLR.L   D3
    
    MOVE.L  #0,D1                       ; Flag load successful
    RTS
    
*************************************************************************************
*
* get a little endian word. returns the result in d0.w and increments the pointer
easy2d_getLong
	BSR.S		easy2d_getWord		; get a little endian word
	SWAP		D0			; move it
	BSR.S		easy2d_getWord	    ; get a little endian word
	SWAP		D0			; swap the words
	RTS
	
*************************************************************************************
*
* get a little endian longword. returns the result in d0.l and increments the pointer
easy2d_getWord
    MOVE.B	(A1)+,D0	    ; get the low byte
	ROL.W		#8,D0		; move it
	MOVE.B	(A1)+,D0		; get the high byte
	ROL.W		#8,D0		; swap the bytes
	RTS

*************************************************************************************
*
* Displays an image to the screen using angle(D0), zoom(D1), x, and y.
* Parameters: A1 - Image data and properties
*             D4.W - x origin
*             D5.W - y origin
* Returns: Nothing
* Affects: D0/D1/D3/D4/D5/D6/D7/A3/A4
    
displayImage
    LEA     easy2d_imageData,A3        ; Load image proerties
    LEA     easy2d_settings,A4         ; Load easy 2D properties
    LEA     easy2d_imFile(A1),A3       ; Point to the file buffer
    ADDA.L  easy2d_imageStart(A1),A3   ; Add the image start offset to A1
    
    MOVE.W  D4,easy2d_originX(A1)      ; update X origin to new value
    
; Calculate end y coordinate
    SUBQ.W  #1,D5
    MOVE.L  easy2d_imHeight(A1),D7
    SUBQ.L  #1,D7
    ADD.W   D7,D5
    
    MOVE.L  easy2d_imWidth(A1),D6
    MOVEQ   #3,D3               ; set byte remainder mask
    AND.L   D6,D3               ; make byte remainder
easy2d_yLoop
    MOVE.L  easy2d_imWidth(A1),D6      ; get the image width
    SUBQ.L  #1,D6               ; make 0 to n
    MOVE.W  easy2d_originX(A1),D4      ; get the image x origin
    SUBQ.W  #1,D4               ; Remove extra px in row
easy2d_xLoop
    MOVEQ   #0,D1               ; clear the long word
    MOVE.B  (A3)+,D1            ; get the blue byte
    SWAP    D1                  ; move it to the high word
    MOVE.B  (A3)+,D1            ; get the green byte
    ROL.W   #8,D1               ; move it to the high byte
    MOVE.B  (A3)+,D1            ; get the red byte
    
    IF.W easy2d_scale(A4) <EQ> #1 THEN
        BSR     easy2d_drawPixel       ; set the pen color and draw the pixel
    ELSE
        BSR     easy2d_drawRect        ; set the pen color and draw the scaled pixel
    ENDI       
    
    DBF     D6,easy2d_xLoop            ; loop for the next pixel
    
    ADDA.W  D3,A3               ; skip the remainder bytes
    SUBQ.W  #1,D5               ; decrement the y coordinate
    DBF     D7,easy2d_yLoop            ; loop for next line
    
    RTS

*************************************************************************************
*
* set the pen colour from d1.l and draw the scaled pixel
easy2d_drawRect
    ADDQ.W      #1,D4
    IF.L easy2d_mask(A4) <EQ> D1 THEN
        RTS
    ELSE
        MOVEM.L     D1-D4,-(SP)   ; store D4 on the stack

        MOVEQ       #80,D0        ; set the pen color
        TRAP        #15
    
        MOVEQ       #81,D0        ; set the fill color
        TRAP        #15

        MOVE.W      D4,D1         ; copy the x coordinate
        MOVE.W      D5,D2         ; copy the y coordinate

    ; Calculate the screen x1 and y1 coordinates for this pixel
        MULU.W      easy2d_scale(A4),D1      ; x1 * scale
        MULU.W      easy2d_scale(A4),D2      ; y1 * scale
    
    ; Calculate the screen x2 and y2 coordinates for this pixel
        MOVE.W      D1,D3         ; x2 = x1
        ADD.W       easy2d_scale(A4),D3      ; x2 = x1 + scale
        MOVE.W      D2,D4         ; y2 = y1
        ADD.W       easy2d_scale(A4),D4      ; y2 = y1 + scale
    
    ; draw pixel
        MOVEQ       #87,D0        ; draw rect
        TRAP        #15
    
        MOVEM.L      (SP)+,D1-D4  ; retrieve D4 from the stack
        RTS
    ENDI
    
    
*************************************************************************************
*
* set the pen colour from d1.l and draw the pixel

easy2d_drawPixel
    ADDQ.W      #1,D4               ; increment the x co-ordinate
    IF.L easy2d_mask(A4) <EQ> D1 THEN
        RTS
    ELSE
	    MOVEQ		#80,D0			; set the pen color
	    TRAP		#15

	    MOVE.W	    D4,D1			; copy the x co-ordinate
	    MOVE.W	    D5,D2			; copy the y co-ordinate

	    MOVEQ		#82,D0			; draw a pixel
	    TRAP		#15
		
	    RTS
	ENDI
	
easy2d_endOfImages DC.L    $2500        ; pointer to the end of images
	
easy2d_settings
    OFFSET  0
easy2d_scale       DS.W    1           ; scale (px per square)
easy2d_mask        DS.L    1           ; mask color for alpha pixels

    ORG     $2500
easy2d_imageData				    ; points to variables base
	OFFSET	0				; use relative addressing

; Image display data
easy2d_originX	    DS.W	1	    ; x origin
easy2d_originY	    DS.W	1		; y origin

; Image file data  
easy2d_fileID	    DS.L	1		; file ID longword
easy2d_fileSize    DS.L    1       ; filesize

easy2d_imageStart  DS.L	1		; offset to the start of the image data

easy2d_imWidth	    DS.L	1	    ; image width
easy2d_imHeight	DS.L	1		; image height
easy2d_imDepth	    DS.W	1		; image depth in bits per pixel

easy2d_imFile		; the rest of the memory is the file buffer










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
