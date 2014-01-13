	;; 
	;; screen-bits.asm
	;;
	;; Various screen- and sprite-related bits
	;;
	;; FIXME: Reverse properly
	;; 


	;; Takes a B = Y, C = X pixel coordinate.
	;; Returns a pointer to corresponding bitmap address in DE.
GetScrMemAddr:	LD	A,B
		AND	A
		RRA
		SCF
		RRA
		AND	A
		RRA
	;; A is now B >> 3 | 0x40
		XOR	B
		AND	$F8
		XOR	B
		LD	D,A
	;; D is now ((B >> 3) | 0x40) & ~0x07  |  B & 0x07
		LD	A,C
		RLCA
		RLCA
		RLCA
	;; A is now C << 3 | C >> 5
		XOR	B
		AND	$C7
		XOR	B
	;; A is now (C << 3 | C >> 5) & ~0x38  |  B & 0x38
		RLCA
		RLCA
		LD	E,A
	;; E is now C >> 3  |  (B << 2) & 0xE0
		RET
	
	;; Screen-wipe loop
ScreenWipe:	LD	E,$04
SW_0:		LD	HL,L4000
		LD	BC,L1800
		PUSH	AF
		; This loop smears to the right...
SW_1:		POP	AF
		LD	A,(HL)
		RRA
		PUSH	AF
		AND	(HL)
		LD	(HL),A
		; (Delay loop)
		LD	D,$0C
SW_2:		DEC	D
		JR	NZ,SW_2
		INC	HL
		DEC	BC
		LD	A,B
		OR	C
		JR	NZ,SW_1
		; This loop smears to the left...
		LD	BC,L1800
SW_3:		DEC	HL
		POP	AF
		LD	A,(HL)
		RLA
		PUSH	AF
		AND	(HL)
		LD	(HL),A
		; (Delay loop)
		LD	D,$0C
SW_4:		DEC	D
		JR	NZ,SW_4
		DEC	BC
		LD	A,B
		OR	C
		JR	NZ,SW_3
		POP	AF
		DEC	E
		; And loop until fully wiped...
		JR	NZ,SW_0
		LD	HL,L4000
		LD	BC,L1800
		JP	FillZero 	; Tail call

	;; Draw a sprite, with attributes.
	;; Source in DE, origin in BC, size in HL, Attribute style in A
	;; (H = Y, L = X, measured in double-pixels)
DrawSprite:	PUSH	AF
		PUSH	BC
		PUSH	DE
		XOR	A
		LD	(BlitYOffset+1),A 	; Y offset for the BlitScreen call
	;; Initialise sprite extents from origin and size.
		LD	D,B
		LD	A,B
		ADD	A,H
		LD	E,A
		LD	(SpriteYExtent),DE
		LD	A,C
		LD	B,C
		ADD	A,L
		LD	C,A
		LD	(SpriteXExtent),BC
		LD	A,L
	;; Put width in bytes into L
		RRCA
		RRCA
		AND	$07
		LD	L,A
	;; Restore source, save byte-oriented size.
		POP	DE
		PUSH	HL
	;; FIXME: Decode this lot.
		LD	C,A
		LD	A,H
		LD	HL,SpriteBuff
DrS_1:		EX	AF,AF'
		LD	B,C
DrS_2:		LD	A,(DE)
		LD	(HL),A
		INC	L
		INC	DE
		DJNZ	DrS_2
		LD	A,$06
		SUB	C
		ADD	A,L
		LD	L,A
		EX	AF,AF'
		DEC	A
		JR	NZ,DrS_1
		CALL	BlitScreen
	;; Prepare to do the attributes
		POP	HL		; Restore byte-oriented size.
		POP	BC		; Restore double-pixel-oriented origin.
		LD	A,C
		SUB	$40
		ADD	A,A
		LD	C,A		; BC now contains single-pixel-oriented origin.
		CALL	GetScrMemAddr
		CALL	ToAttrAddr 	; DE now contains pointer to starting attribute.
		LD	A,H		; Divide height by 8, as we're working with attributes...
		RRA
		RRA
		RRA
		AND	$1F
		LD	H,A
		POP	AF		; Now get attribute style.
		ADD	A,Attrib0 & $FF
		LD	C,A
		ADC	A,Attrib0 >> 8		
		SUB	C
		LD	B,A
		LD	A,(BC)		; Fetch Attrib0[A]
	;; Now actually do the attribute-writing work
		EX	DE,HL
	;; D now holds height, E width, HL starting point.
	;; Outer, vertical loop.
DrS_3:		LD	B,E
	;; Row-drawing loop.
		LD	C,L		; Save start point.
DrS_4:		LD	(HL),A
		INC	L
		DJNZ	DrS_4
		LD	L,C		; Restore start point
		LD	BC,L0020
		ADD	HL,BC		; Move down a row.
		DEC	D
		JR	NZ,DrS_3 	; Repeat as necessary.
	;; FIXME
		LD	A,$48
		LD	(BlitYOffset+1),A 	; Y offset for the BlitScreen call
		RET

	;; Converts a bitmap address to its corresponding attribute address.
	;; Works on an address in DE.
	;; Divide by 8, take bottom 2 bits, tack on $58 (top byte of attribute table address)
ToAttrAddr:	LD	A,D
		RRA
		RRA
		RRA
		AND	$03
		OR	$58
		LD	D,A
		RET

	;; Draw the diagonal edge-of-screen attribute lines.
ApplyAttribs:	LD	BC,(RoomOrigin)
		LD	A,C
		SUB	$40
		ADD	A,A
		LD	C,A
		LD	A,B
		SUB	$3D
		LD	B,A
		CALL	GetScrMemAddr
		LD	L,D		; Save high byte of address - why?
		CALL	ToAttrAddr
		EX	DE,HL

		PUSH	HL
	;; Write out Attrib2 over HL, in a diagonal line up the right, 2:1 gradient.
		LD	A,L
		AND	$1F
		NEG
		ADD	A,$20
		LD	B,A
		LD	A,(Attrib2)
		LD	C,A
		CALL	ApplyAttribs1

		POP	HL
	;; Write out Attrib1 over HL, in a diagonal line up the left, 2:1 gradient.
		LD	A,L
		DEC	L
		AND	$1F
		LD	B,A 	; Initialise count with X coordinate from address.

		LD	A,(Attrib1)
		LD	C,A

		BIT	2,E
		JR	Z,AA_2		; Do we start with up and left, or left?
AA_1:		LD	(HL),C
		DEC	B
		RET	Z
	;; Left one 
		DEC	L
AA_2:		LD	(HL),C
	;; Up one line
		LD	A,L
		SUB	$20
		LD	L,A
		JR	NC,AA_3
		DEC	H
AA_3:		LD	(HL),C
	;; Left one
		DEC	L
		DJNZ	AA_1
		RET

ApplyAttribs1:	BIT	2,E
		JR	Z,AA1_2		; Do we start with up and right or up?
AA1_1:		LD	(HL),C
		DEC	B
		RET	Z
	;; Right one
		INC	L
AA1_2:		LD	(HL),C
	;; Up one line
		LD	A,L
		SUB	$20
		LD	L,A
		JR	NC,AA1_3
		DEC	H
AA1_3:		LD	(HL),C
	;; Right one
		INC	L
		DJNZ	AA1_1
		RET
