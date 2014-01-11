	;; 
	;; character.asm
	;;
	;; Does a lot of stuff which seems to care about Character.
	;;
	;; Looks like it hangs together, but needs a lot of
	;; reverse-engineering
	;; 

	;; Exported functions:
	;; * CharThing
	;; * CharThing3
	;; * CharThing11
	;; * CharThing14
	;; * CharThing15
	;; * CharThing17

	;; Unknown functions that are called:
	;; L72A0
	;; L8CD6
	;; L8CF0
	;; L8D7F
	;; L8E1D
	;; LA05D
	;; LA0A5
	;; LA316
	;; LAA74
	;; LAC12
	;; LAC41
	;; LAF96
	;; LB010
	;; LB03B
	;; LB0BE
	;; LB0C6
	;; LB21C
	
	
	;; Something of an epic function...
	;; Think it involves general movement/firing etc.
CharThing:	LD	A,(LA314)
		RLA
		CALL	C,LA316
		LD	HL,LB219
		LD	A,(HL)
		AND	A
		JR	Z,EPIC_1
		EXX
		LD	HL,Character
		LD	A,(LB21A)
		AND	(HL)
		EXX
		JP	NZ,CharThing2 		; NB: Tail call
		CALL	CharThing2
EPIC_1:		LD	HL,LA296
		LD	A,(HL)
		AND	A
		JP	NZ,EPIC_14
		INC	HL
		OR	(HL)
		JP	NZ,EPIC_13
		LD	HL,LA298
		DEC	(HL)
		JR	NZ,EPIC_2
		LD	(HL),$03
		LD	HL,(Character)
		LD	A,H
		ADD	A,A
		OR	H
		OR	L
		RRA
		PUSH	AF
		LD	A,$02
		CALL	C,DecCount
		POP	AF
		RRA
		LD	A,$03
		CALL	C,DecCount
EPIC_2:		LD	A,$FF
		LD	(LA2BF),A
		LD	A,(LB218)
		AND	A
		JR	Z,EPIC_4
		LD	A,(LA2BC)
		AND	A
		JR	Z,EPIC_3
		LD	A,(LA2BB)
		SCF
		RLA
		LD	(CurrDir),A
		JR	EPIC_4
EPIC_3:		LD	(LB218),A
EPIC_4:		CALL	CharThing4
	;; NB: Big loop back up to here.
EPIC_5:		CALL	CharThing14
		PUSH	HL
		POP	IY
		LD	A,(IY+$07)
		CP	$84
		JR	NC,EPIC_6
		XOR	A
		LD	(LA29F),A
		LD	A,(L7712)
		AND	A
		JR	NZ,EPIC_6
		LD	A,$06
		LD	(LB218),A
	;; Check for Fire being pressed
EPIC_6:		LD	A,(FirePressed)
		RRA
		JR	NC,EPIC_8
		LD	A,(Character)
		OR	$FD
		INC	A
		LD	HL,LA2BC
		OR	(HL)
		JR	NZ,EPIC_7 ; Jumps if not Head (alone) or ...
		LD	A,(LA28B)
		OR	$F9
		INC	A
		JR	NZ,EPIC_7
		LD	A,(LA2B8)
		CP	$08
		JR	NZ,EPIC_7
		LD	HL,LA2D7
		LD	DE,LA2AE
		LD	BC,L0003
		LDIR
		LD	HL,LA2A9
		PUSH	HL
		POP	IY
		LD	A,(L703D)
		OR	$19
		LD	(LA2B3),A
		LD	(IY+$04),$00
		LD	A,(LA2BB)
		LD	(LA2B4),A
		LD	(IY+$0C),$FF
		LD	(IY+$0F),$20
		CALL	LB03B
		LD	A,$06
		CALL	DecCount
		LD	B,$48
		CALL	PlaySound
		LD	A,(Donuts)
		AND	A
		JR	NZ,EPIC_8
		LD	HL,LA28B
		RES	2,(HL)
		CALL	L8E1D
		JR	EPIC_8
EPIC_7:		CALL	NopeNoise
EPIC_8:		LD	HL,LB218
		LD	A,(HL)
		AND	$7F
		RET	Z
		LD	A,(LB219)
		AND	A
		JR	Z,EPIC_9
		LD	(HL),$00
		RET
EPIC_9:		LD	A,(LA295)
		AND	A
		JR	Z,EPIC_12
		CALL	CharThing14
		PUSH	HL
		POP	IY
		CALL	LB0C6
		LD	A,(Character)
		CP	$03
		JR	Z,EPIC_12
		LD	HL,LA2A6
		CP	(HL)
		JR	Z,EPIC_10
		XOR	$03
		LD	(HL),A
		JR	EPIC_11
EPIC_10:	LD	HL,LFB49
		LD	DE,LA2A2
		LD	BC,L0005
		LDIR
EPIC_11:	LD	HL,L0000
		LD	(LA2CD),HL
		LD	(LA2DF),HL
		CALL	L72A0
EPIC_12:	LD	HL,L0000
		LD	(LA2A7),HL
		JP	L70BA
EPIC_13:	DEC	(HL)
		LD	HL,(Character)
		JP	CharThing18 		; NB: Tail call
EPIC_14:	DEC	(HL)
		LD	HL,(Character)
		JP	NZ,CharThing19 		; NB: Tail call
		LD	A,$07
		LD	(LB218),A
		JP	EPIC_5

	
CharThing2:	DEC	(HL)
		JP	NZ,CharThing20 		; NB: Tail call
		LD	HL,L0000
		LD	(LA2A7),HL
		LD	HL,Lives
		LD	BC,(LB21A)
		LD	B,$02
		LD	D,$FF
EPIC_16:	RR	C
		JR	NC,EPIC_17
		LD	A,(HL)
		SUB	$01
		DAA
		LD	(HL),A
		JR	NZ,EPIC_17
		LD	D,$00
EPIC_17:	INC	HL
		DJNZ	EPIC_16
		DEC	HL
		LD	A,(HL)
		DEC	HL
		OR	(HL)
		JP	Z,FinishGame
		LD	A,D
		AND	A
		JR	NZ,EPIC_24
		LD	HL,Lives
		LD	A,(LA295)
		AND	A
		JR	Z,EPIC_21
		LD	A,(LA2A6)
		CP	$03
		JR	NZ,EPIC_19
		LD	A,(HL)
		AND	A
		LD	A,$01
		JR	NZ,EPIC_18
		INC	A
EPIC_18:	LD	(LA2A6),A
		JR	EPIC_24
EPIC_19:	RRA
		JR	C,EPIC_20
		INC	HL
EPIC_20:	LD	A,(HL)
		AND	A
		JR	NZ,EPIC_23
		LD	(LA295),A
EPIC_21:	CALL	SwitchChar
		LD	HL,L0000
		LD	(LB219),HL
EPIC_22:	LD	HL,LFB28
		SET	0,(HL)
		RET
EPIC_23:	CALL	EPIC_22
EPIC_24:	LD	A,(LA2A6)
		LD	(Character),A
		CALL	CharThing3
		CALL	CharThing14
		LD	DE,L0005
		ADD	HL,DE
		EX	DE,HL
		LD	HL,LA2A3
		LD	BC,L0003
		LDIR
		LD	A,(LA2A2)
		LD	(LB218),A
		JP	L70E6

CharThing18:	PUSH	HL
		LD	HL,LA30A
		JR	CharThing21 		; NB: Tail call
	
CharThing20:	LD	HL,(LB21A)
	;; NB: Fall through
	
CharThing19:	PUSH	HL
		LD	HL,LA2FC
	;; NB: Fall through

CharThing21:	LD	IY,LA2C0
		CALL	L8CF0
		POP	HL
		PUSH	HL
		BIT	1,L
		JR	Z,EPIC_29
		PUSH	AF
		LD	(LA2DA),A
		RES	3,(IY+$16)
		LD	HL,LA2D2
		CALL	LA05D
		LD	HL,LA2D2
		CALL	LA0A5
		POP	AF
EPIC_29:	POP	HL
		RR	L
		RET	NC
		XOR	$80
		LD	(LA2C8),A
		RES	3,(IY+$04)
		LD	HL,LA2C0
		CALL	LA05D
		LD	HL,LA2C0
		JP	LA0A5			; NB: Tail call
	
CharThing3:	AND	$01
		RLCA
		RLCA
		LD	HL,SwopPressed
		RES	2,(HL)
		OR	(HL)
		LD	(HL),A
		RET

	;; Looks like more movement stuff
CharThing4:	CALL	CharThing14
		PUSH	HL
		POP	IY
		LD	A,$3F
		LD	(LA2BD),A
		LD	A,(LA2BC)
		CALL	LAF96
		CALL	CharThing14
		CALL	LA05D
		LD	HL,LA29F
		LD	A,(HL)
		AND	A
		JR	Z,EPIC_37
		LD	A,(LA2BC)
		AND	A
		JR	Z,EPIC_31
		LD	(HL),$00
		JR	EPIC_37
EPIC_31:	DEC	(HL)
		CALL	CharThing14
		CALL	LAC41
		JR	C,EPIC_32
		DEC	(IY+$07)
		LD	A,$84
		CALL	CharThing12
		JR	EPIC_33
EPIC_32:	EX	AF,AF'
		LD	A,$88
		BIT	4,(IY+$0B)
		SET	4,(IY+$0B)
		CALL	Z,CharThing12
		EX	AF,AF'
		JR	Z,EPIC_34
EPIC_33:	RES	4,(IY+$0B)
		SET	5,(IY+$0B)
		DEC	(IY+$07)
EPIC_34:	LD	A,(Character)
		AND	$02
		JR	NZ,EPIC_36
EPIC_35:	LD	A,(LA2BB)
		JP	EPIC_43
EPIC_36:	LD	A,(CurrDir)
		RRA
		CALL	LookupDir
		INC	A
		JP	NZ,EPIC_42
		JR	EPIC_35
EPIC_37:	SET	4,(IY+$0B)
		SET	5,(IY+$0C)
		CALL	CharThing14
		LD	A,(LB218)
		AND	A
		JR	NZ,EPIC_38
		CALL	LAA74
		JP	NC,CharThing23 		; NB: Tail call
		JP	NZ,CharThing22		; NB: Tail call
EPIC_38:	LD	A,(LB218)
		RLA
		JR	NC,EPIC_39
		LD	(IY+$0C),$FF
EPIC_39:	LD	A,$86
		BIT	5,(IY+$0B)
		SET	5,(IY+$0B)
		CALL	Z,CharThing12 		; NB: Tail call
		BIT	4,(IY+$0C)
		SET	4,(IY+$0C)
		JR	NZ,EPIC_41
		CALL	CharThing14
		CALL	LAC41
		JR	NC,EPIC_40
		JR	NZ,EPIC_40
		LD	A,$88
		CALL	CharThing12
		JR	EPIC_41
EPIC_40:	DEC	(IY+$07)
		RES	4,(IY+$0B)
EPIC_41:	XOR	A
		LD	(LA29E),A
		CALL	CharThing10
		CALL	CharThing9
EPIC_42:	LD	A,(CurrDir)
		RRA
EPIC_43:	CALL	CharThing7
		CALL	CharThing6
		EX	AF,AF'
		LD	A,(LA2A0)
		INC	A
		JR	NZ,EPIC_46
		XOR	A
		LD	HL,Character
		BIT	0,(HL)
		JR	Z,EPIC_44
		LD	(LA2E4),A
		LD	(LA2EA),A
EPIC_44:	BIT	1,(HL)
		JR	Z,EPIC_45
		LD	(LA2F0),A
		LD	(LA2F6),A
EPIC_45:	EX	AF,AF'
		LD	BC,L1B21
		JR	C,EPIC_50
		CALL	CharThing5
		LD	BC,L181F
		JR	EPIC_50
EPIC_46:	EX	AF,AF'
		LD	HL,LA2E4
		LD	DE,LA2F0
		JR	NC,EPIC_47
		LD	HL,LA2EA
		LD	DE,LA2F6
EPIC_47:	PUSH	DE
		LD	A,(Character)
		RRA
		JR	NC,EPIC_48
		CALL	L8CF0
		LD	(LA2C8),A
EPIC_48:	POP	HL
		LD	A,(Character)
		AND	$02
		JR	Z,EPIC_49
		CALL	L8CF0
		LD	(LA2DA),A
EPIC_49:	SET	5,(IY+$0B)
		JR	CharThing26
EPIC_50:	SET	5,(IY+$0B)
	;; NB: Fall through

CharThing25:	LD	A,(Character)
		RRA
		JR	NC,EPIC_52
		LD	(IY+$08),B
EPIC_52:	LD	A,(Character)
		AND	$02
		JR	Z,CharThing26 		; NB: Tail call
		LD	A,C
		LD	(LA2DA),A
	;; NB: Fall through
	
CharThing26:	LD	A,(LA2BF)
		LD	(IY+$0C),A
		CALL	CharThing14
		CALL	LB0BE
		CALL	CharThing16
		XOR	A
		CALL	LAF96
		CALL	CharThing14
		CALL	LA0A5
		JP	CharThing13 		; NB: Tail call
	
CharThing5:	LD	HL,LA315
		DEC	(HL)
		LD	A,$03
		SUB	(HL)
		RET	C
		JR	Z,EPIC_55
		CP	$03
		RET	NZ
		LD	(HL),$40
EPIC_55:	JP	LA316
	
CharThing22:	LD	HL,LA29E
		LD	A,(HL)
		AND	A
		LD	(HL),$FF
		JR	Z,CharThing24 		; NB: Tail call
		CALL	CharThing10
		CALL	CharThing9
		XOR	A
		JR	CharThing24 		; NB: Tail call
	
CharThing23:	XOR	A
		LD	(LA29E),A
		INC	A
	;; NB: Fall through
CharThing24:	LD	C,A
		CALL	CharThing8
		RES	5,(IY+$0B)
		LD	A,(Character)
		AND	$02
		JR	NZ,EPIC_59
		DEC	C
		JR	NZ,EPIC_60
		INC	(IY+$07)
EPIC_59:	INC	(IY+$07)
		AND	A
		JR	NZ,EPIC_61
		LD	A,$82
		CALL	CharThing12
		LD	HL,LA293
		LD	A,(HL)
		AND	A
		JR	Z,EPIC_63
		DEC	(HL)
		LD	A,(LA2BB)
		JR	EPIC_62
EPIC_60:	INC	(IY+$07)
EPIC_61:	LD	A,$83
		CALL	CharThing12
		LD	A,(CurrDir)
		RRA
EPIC_62:	CALL	CharThing7
EPIC_63:	CALL	CharThing6
		LD	BC,L1B21
		JP	C,CharThing25
		LD	BC,L184D
		JP	CharThing25

CharThing6:	LD	A,(LA2BB)
		CALL	LookupDir
		RRA
		RES	4,(IY+$04)
		RRA
		JR	C,EPIC_65
		SET	4,(IY+$04)
EPIC_65:	RRA
		RET


	;; Another character-updating function
CharThing7:	OR	$F0
		CP	$FF
		LD	(LA2A0),A
		JR	Z,EPIC_66
		EX	AF,AF'
		XOR	A
		LD	(LA2A0),A
		LD	A,$80
		CALL	CharThing12
		EX	AF,AF'
		LD	HL,LA2BB
		CP	(HL)
		LD	(HL),A
		JR	Z,EPIC_67
EPIC_66:	CALL	CharThing8
		LD	A,$FF
EPIC_67:	PUSH	AF
		AND	A,(IY+$0C)
		CALL	LookupDir
		CP	$FF
		JR	Z,EPIC_68
		CALL	CharThing14
		CALL	LB21C
		JR	NC,EPIC_69
		LD	A,(IY+$0B)
		OR	$F0
		INC	A
		LD	A,$88
		CALL	NZ,CharThing12
EPIC_68:	POP	AF
		LD	A,(IY+$0B)
		OR	$0F
		LD	(IY+$0B),A
		RET
EPIC_69:	CALL	CharThing14
		CALL	L8CD6
		POP	BC
		LD	HL,LA2A1
		LD	A,(HL)
		AND	A
		JR	Z,EPIC_70
		DEC	(HL)
		RET
EPIC_70:	LD	HL,Speed ; FIXME: Fast if have Speed or are Heels...
		LD	A,(Character)
		AND	$01
		OR	(HL)
		RET	Z
		LD	HL,LA299
		DEC	(HL)
		PUSH	BC
		JR	NZ,EPIC_71
		LD	(HL),$02
		LD	A,(Character)
		RRA
		JR	C,EPIC_71
		LD	A,$00
		CALL	DecCount
EPIC_71:	LD	A,$81
		CALL	CharThing12
		POP	AF
		CALL	LookupDir
		CP	$FF
		RET	Z
		CALL	CharThing14
		PUSH	HL
		CALL	LB21C
		POP	HL
		JP	NC,L8CD6
		LD	A,$88
		JP	CharThing12 	; NB: Tail call
	
CharThing8:	LD	A,$02
		LD	(LA2A1),A
		RET


	
CharThing9:	LD	A,(Character)
		LD	B,A
		DEC	A
		JR	NZ,EPIC_72
		XOR	A
		LD	(LA293),A
EPIC_72:	LD	A,(LA2BC)
		AND	A
		RET	NZ
		LD	A,(CurrDir)
		RRA
		RET	C
		LD	C,$00
		LD	L,(IY+$0D)
		LD	H,(IY+$0E)
		LD	A,H
		OR	L
		JR	Z,EPIC_75
		PUSH	HL
		POP	IX
		BIT	0,(IX+$09)
		JR	Z,EPIC_73
		LD	A,(IX+$0B)
		OR	$CF
		INC	A
		RET	NZ
EPIC_73:	LD	A,(IX+$08)
		AND	$7F
		CP	$57
		JR	Z,EPIC_80
		CP	$2B
		JR	Z,EPIC_74
		CP	$2C
		JR	NZ,EPIC_75
EPIC_74:	INC	C
EPIC_75:	LD	A,(Character)
		AND	$02
		JR	NZ,EPIC_76
		PUSH	BC
		LD	A,$01
		CALL	DecCount
		POP	BC
		JR	Z,EPIC_77
EPIC_76:	INC	C
EPIC_77:	LD	A,C
		ADD	A,A
		ADD	A,A
		ADD	A,$04
		CP	$0C
		JR	NZ,EPIC_78
		LD	A,$0A
EPIC_78:	LD	(LA29F),A
		LD	A,$85
		DEC	B
		JR	NZ,EPIC_79
		LD	HL,LA293
		LD	(HL),$07
EPIC_79:	JP	CharThing12 	; NB: Tail call
EPIC_80:	LD	HL,L080C
		LD	(LA296),HL
		LD	B,$C7
		JP	PlaySound


	
CharThing10:	LD	A,(CarryPressed)
		RRA
		RET	NC
		LD	A,(LA28B)
		RRA
EPIC_81:	JP	NC,NopeNoise
		LD	A,(Character)
		AND	$01
		JR	Z,EPIC_81
		LD	A,$87
		CALL	CharThing12
		LD	A,(LA2A8)
		AND	A
		JR	NZ,EPIC_82
		CALL	CharThing14
		CALL	LAC12
		JR	NC,EPIC_81
		LD	A,(IX+$08)
		PUSH	HL
		LD	(LA2A7),HL
		LD	BC,LD8B0
		PUSH	AF
		CALL	Draw3x24
		POP	AF
		POP	HL
		JP	L8D4B
EPIC_82:	LD	A,(LA2BC)
		AND	A
		JP	NZ,NopeNoise
		LD	C,(IY+$07)
		LD	B,$03
EPIC_83:	CALL	CharThing14
		PUSH	BC
		CALL	LAC41
		POP	BC
		JR	C,EPIC_84
		DEC	(IY+$07)
		DEC	(IY+$07)
		DJNZ	EPIC_83
		LD	HL,(LA2A7)
		PUSH	HL
		LD	DE,L0007
		ADD	HL,DE
		PUSH	HL
		CALL	CharThing14
		LD	DE,L0006
		ADD	HL,DE
		EX	DE,HL
		POP	HL
		LD	(HL),C
		EX	DE,HL
		DEC	DE
		LDD
		LDD
		POP	HL
		CALL	L8D7F
		LD	HL,L0000
		LD	(LA2A7),HL
		LD	BC,LD8B0
		CALL	Clear3x24
		CALL	CharThing14
		CALL	LAA74
		CALL	CharThing14
		JP	LA05D
EPIC_84:	LD	(IY+$07),C
		JP	NopeNoise

CharThing11:	LD	HL,LA2BE 	; FIXME: Unused?
		JR	EPIC_85

CharThing12:	LD	HL,LA2BD
EPIC_85:	CP	(HL)
		RET	C
		LD	(HL),A
		RET
	
CharThing13:	LD	A,(LA2BD)
		OR	$80
		LD	B,A
		CP	$85
		JP	NC,PlaySound
		LD	A,(MENU_SOUND)
		AND	A
		RET	NZ
		JP	PlaySound
	
CharThing14:	LD	HL,Character
		BIT	0,(HL)
		LD	HL,LA2C0
		RET	NZ
		LD	HL,LA2D2
		RET


	
CharThing15:	XOR	A 	; FIXME: Unused?
		LD	(LA2FC),A
		LD	(LA296),A
		LD	(LA30A),A
		LD	A,$08
		LD	(LA2B8),A
		CALL	SetCharThing
		LD	A,(Character)
		LD	(LA2A6),A
		CALL	CharThing14
		PUSH	HL
		PUSH	HL
		PUSH	HL
		POP	IY
		LD	A,(LB218)
		LD	(LA2A2),A
		PUSH	AF
		SUB	$01
		PUSH	AF
		CP	$04
		JR	NC,EPIC_86
		XOR	$01
		LD	E,A
		LD	D,$00
		LD	HL,L7744
		ADD	HL,DE
		LD	C,(HL)
		LD	HL,LAA6E
		ADD	HL,DE
		LD	A,(L7716)
		AND	(HL)
		JR	NZ,EPIC_86
		LD	(IY+$07),C
EPIC_86:	CALL	CharThing14
		LD	DE,L0005
		ADD	HL,DE
		EX	DE,HL
		POP	AF
		JR	C,EPIC_93
		CP	$06
		JR	Z,EPIC_90
		JR	NC,EPIC_92
		CP	$04
		JR	NC,EPIC_88
		LD	HL,L7718
		LD	C,$FD
		RRA
		JR	NC,EPIC_87
		INC	DE
		INC	HL
EPIC_87:	RRA
		JR	C,EPIC_95
		LD	C,$03
		INC	HL
		INC	HL
		JR	EPIC_95
EPIC_88:	INC	DE
		INC	DE
		RRA
		LD	A,$84
		JR	NC,EPIC_89
		LD	A,(L7B8F)
		AND	A
		LD	A,$BA
		JR	Z,EPIC_89
		LD	A,$B4
EPIC_89:	LD	(DE),A
		POP	AF
		JR	EPIC_97
EPIC_90:	INC	DE
		INC	DE
		LD	A,(L7B8F)
		AND	A
		JR	Z,EPIC_91
		LD	A,(DE)
		SUB	$06
		LD	(DE),A
EPIC_91:	LD	B,$C8
		CALL	PlaySound
		JR	EPIC_96
EPIC_92:	LD	HL,L8ADF
		JR	EPIC_94
EPIC_93:	LD	HL,LAA64
EPIC_94:	LDI
		LDI
		LDI
		JR	EPIC_96
EPIC_95:	LD	A,(HL)
		ADD	A,C
		LD	(DE),A
EPIC_96:	POP	AF
		ADD	A,$67
		LD	L,A
		ADC	A,$AA
		SUB	L
		LD	H,A
		LD	A,(HL)
		LD	(LA2BB),A
EPIC_97:	LD	A,$80
		LD	(LB218),A
		POP	HL
		LD	DE,L0005
		ADD	HL,DE
		LD	DE,LA2A3
		LD	BC,L0003
		LDIR
		LD	(IY+$0D),$00
		LD	(IY+$0E),$00
		LD	(IY+$0B),$FF
		LD	(IY+$0C),$FF
		POP	HL
		CALL	LB010
		CALL	CharThing16
		XOR	A
		LD	(LB219),A
		LD	(LB21A),A
		LD	(L7B8F),A
		JP	LAF96
	
CharThing16:	LD	A,(LAF77)
		LD	(LA2BC),A
		RET

	
CharThing17:	LD	A,(Character) 	; FIXME: Unused?
		LD	HL,LA295
		RRA
		OR	(HL)
		RRA
		RET	NC
		LD	HL,(LA2A7)
		INC	H
		DEC	H
		RET	Z
		LD	DE,L0008
		ADD	HL,DE
		LD	A,(HL)
		LD	BC,LD8B0
		JP	Draw3x24

LAA64:	DEFB $28,$28,$C0,$FD,$FD,$FB,$FE,$F7,$FD,$FD
LAA6E:	DEFB 08,$04,$02,$01
