	;;
	;; Walls.asm
	;;
	;; Handles configuring the walls a the back of the room.
	;;

PanelBase:	DEFW $0000
PanelFlipsPtr:	DEFW $0000	; Pointer to byte full of whether walls need to flip
L84C7:	DEFB $00
L84C8:	DEFB $00
CornerX:	DEFB $00
DoorZ:	DEFB $00

StoreCorner:	CALL	GetCorner
		LD	A,C
		SUB	$06
		LD	C,A
		ADD	A,B
		RRA
		LD	(L84C7),A ; Store (C + B - 6) / 2 (= 43 - MaxV)
		LD	A,B
		NEG
		ADD	A,C
		RRA
		LD	(L84C8),A ; Store (C - B) / 2 (= -36 - MaxU)
		LD	A,B
		LD	(CornerX),A ; Store B
		RET

;; Configure the walls.
;;
;; Door height in A
BothWalls:	LD	(DoorZ),A
        ;; Do the V wall case before doing the U wall in this function.
		CALL	VWall
        ;; Skip if there's an extra room visible in the U dir.
		LD	A,(DoorFlags1)
		AND	$04
		RET	NZ
        ;; 
		LD	B,$04
		EXX
		LD	A,$80
		LD	(OWFlag+1),A
		CALL	GetCorner
		LD	DE,L0002
		LD	A,(IY-$01) ; MaxV
		SUB	(IY-$03)   ; MinV
		JR	OneWall    ; NB: Tail call.

;; Draw wall parallel to U axis.
VWall:
        ;; Skip if there's an extra room in the V direction.
		LD	A,(DoorFlags1)
		AND	$08
		RET	NZ
        ;; 
		LD	B,$08
		EXX
		XOR	A
		LD	(OWFlag+1),A
		CALL	GetCorner
		DEC	L
		DEC	L
		LD	DE,LFFFE
		LD	A,(IY-$02) ; MaxU
		SUB	(IY-$04)   ; MinU
	;; NB: Fall through

        ;; Extent in A, movement step in DE, BkgndData pointer in HL, X/Y in B/C
        ;; DoorFlags1 in A', the flag for this wall in B'
OneWall:
        ;; Divide wall extent by 16 (one panel?) 
		RRA
		RRA
		RRA
		RRA
		AND	$0F
        ;; Move BkgndData pointer to IX.
		PUSH	HL
		POP	IX
		EXX
        ;; Updated extent in C, check flag that was in B' against DoorFlags2.
		LD	C,A
		LD	A,(DoorFlags2)
		AND	B
		CP	$01
        ;; Stash it in F'
		EX	AF,AF'

	;; Do a bunch of WorldId-based configuration...
		LD	A,(WorldId)
		LD	B,A
	;; Put PanelFlips + WorldId into PanelFlipsPtr.
		ADD	A,+((PanelFlips - MAGIC_OFFSET) & $FF)
		LD	L,A
		ADC	A,+((PanelFlips - MAGIC_OFFSET) >> 8)
		SUB	L
		LD	H,A
		LD	(PanelFlipsPtr),HL
	;; We use the FetchData mechanism to unpack the WorldData. Set it up.
		LD	A,B
		ADD	A,A
		LD	B,A 		; B updated to 2x
		ADD	A,A
		ADD	A,A   		; A is 8x
		ADD	A,+((WorldData - 1) & $FF)
		LD	L,A
		ADC	A,+((WorldData - 1) >> 8)
		SUB	L
		LD	H,A   		; HL is WorldData - 1 + 8xWorldId
		LD	(DataPtr),HL
		LD	A,$80
		LD	(CurrData),A
	;; Update PanelBase
		LD	A,PanelBases & $FF
		ADD	A,B
		LD	L,A
		ADC	A,PanelBases >> 8
		SUB	L
		LD	H,A 		; HL is PanelBases + 2 x WorldId
		LD	A,(HL)
		INC	HL
		LD	H,(HL)
		LD	L,A
		LD	(PanelBase),HL	; Set the panel codes for the current world.
	;; Do something with the data.
		LD	A,$FF
        ;; Recover the flag, stick the extent in A, push A and flag.
		EX	AF,AF'
		LD	A,C
		PUSH	AF
        ;; Extent = 4 -> B = $01
		SUB	$04
		LD	B,$01
		JR	Z,OW_1
        ;; Extent = 5 -> B = $0F
		LD	B,$0F
		INC	A
		JR	Z,OW_1
        ;; Extent = 6 -> B = $19
		LD	B,$19
		INC	A
		JR	Z,OW_1
        ;; Otherwise, B = $1F
		LD	B,$1F
OW_1:		POP	AF
		JR	C,OW_2  ; If we jump, A' is $FF
        ;; Flag bit was set.
		LD	A,C
		ADD	A,A
		ADD	A,B
		LD	B,A     ; Add 2xC to B
		LD	A,C
		EX	AF,AF'  ; And put C (extent) in A'
        ;; Skip B entries
OW_2:		CALL	FetchData2b
		DJNZ	OW_2
        ;; Put 2x extent in B.
		LD	B,C
		SLA	B
        ;; Then enter the wall-panel-processing loop.
OWPanel:	EX	AF,AF'
        ;; Loop through A panels, then hit OWDoor.
		DEC	A
		JR	Z,OWDoor
        ;; Otherwise update entries in BkgndData.
		EX	AF,AF'
OWFlag:		OR	$00		; NB: Target of self-modifying code.
		LD	(IX+$01),A
		EXX
		LD	A,C
		ADD	A,$08
		LD	(IX+$00),C
		LD	C,A
		ADD	IX,DE
		EXX
		CALL	FetchData2b
OWPanelLoop:	DJNZ	OWPanel
        ;; Loop is complete, tidy up. FIXME:
		EXX
		PUSH	IX
		POP	HL
		LD	A,L
		CP	$40
		RET	NC
		LD	A,(IX+$00)
		AND	A
		RET	NZ
		LD	A,(OWFlag+1)
		OR	$05
		LD	(IX+$01),A
		LD	A,C
		SUB	$10
		LD	(IX+$00),A
		RET

OWDoor:		EXX
		LD	A,(DoorZ)
		AND	A
		LD	A,C
		JR	Z,OWD_1
		ADD	A,$10
		LD	C,A
OWD_1:		SUB	$10
		LD	(IX+$00),A
		LD	A,(OWFlag+1)
		OR	$04
		LD	(IX+$01),A
		ADD	IX,DE
		LD	(IX+$01),A
		LD	A,C
		SUB	$08
		LD	(IX+$00),A
		ADD	A,$18
		LD	C,A
		LD	A,(DoorZ)
		AND	A
		JR	Z,OWD_2
		LD	A,C
		SUB	$10
		LD	C,A
OWD_2:		ADD	IX,DE
		LD	A,$FF
		EX	AF,AF'
		EXX
		DEC	B
		JR	OWPanelLoop

	;; Call FetchData for 2 bits
FetchData2b:	PUSH	BC
		LD	B,$02
		CALL	FetchData
		POP	BC
		RET

;; Gets values associated with the far back corner of the screen.
GetCorner:
        ;; Calculate X coordinate of max U, max V position into B
		LD	A,(IY-$02) ; MaxU
		LD	D,A
		LD	E,(IY-$01) ; MaxV
		SUB	E
		ADD	A,$80
		LD	B,A
		RRA
		RRA
        ;; And the associated BkgndData pointer into HL.
		AND	$3E
		LD	L,A
		LD	H,BkgndData >> 8
        ;; Y coordinate of max U/V in C?
		LD	A,$07
		SUB	E
		SUB	D
		LD	C,A
		RET

PanelBases:	DEFW IMG_WALLS - MAGIC_OFFSET + $70 * 0		; Blacktooth
		DEFW IMG_WALLS - MAGIC_OFFSET + $70 * 3		; Market
		DEFW IMG_WALLS - MAGIC_OFFSET + $70 * 6		; Egyptus
		DEFW IMG_WALLS - MAGIC_OFFSET + $70 * 8		; Penitentiary
		DEFW IMG_WALLS - MAGIC_OFFSET + $70 * 10	; Moon base
		DEFW IMG_WALLS - MAGIC_OFFSET + $70 * 14	; Book world
		DEFW IMG_WALLS - MAGIC_OFFSET + $70 * 16	; Safari
		DEFW IMG_WALLS - MAGIC_OFFSET + $70 * 19	; Prison
	;; 8-byte chunks referenced by setting DataPtr etc.
        ;; Consists of packed 2-bit values.
WorldData:	DEFB $46,$91,$65,$94,$A1,$69,$69,$AA
		DEFB $49,$24,$51,$49,$12,$44,$92,$A4
		DEFB $04,$10,$10,$41,$04,$00,$44,$00
		DEFB $04,$10,$10,$41,$04,$00,$10,$00
		DEFB $4E,$31,$B4,$E7,$4E,$42,$E4,$99
		DEFB $45,$51,$50,$51,$54,$55,$55,$55
		DEFB $64,$19,$65,$11,$A4,$41,$28,$55
		DEFB $00,$00,$00,$00,$00,$00,$00,$00