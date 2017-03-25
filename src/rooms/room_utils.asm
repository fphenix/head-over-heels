;;
;; room_utils.asm
;;
;; A couple of utility functions for loading room state
;;

	;; Fetch bit-packed data.
	;; Expects number of bits in B.
	
	;; End marker is the set bit rotated in from carry: The
	;; current byte is all read when only that bit remains.
FetchData:	LD	DE,CurrData
		LD	A,(DE)
		LD	HL,(DataPtr)
		LD	C,A
		XOR	A
FD_1:		RL	C
		JR	Z,FD_3
FD_2:		RLA
		DJNZ	FD_1
		EX	DE,HL
		LD	(HL),C
		RET
	;; Next character case: Load/initially rotate the new character, and jump back.
FD_3:		INC	HL
		LD	(DataPtr),HL
		LD	C,(HL)
		SCF
		RL	C
		JP	FD_2

CallBothWalls:	LD	HL,(DoorLocs)
        ;; Take the smaller of H and L.
		LD	A,L
		CP	H
		JR	C,CBW_1
		LD	A,H
        ;; Take it away from C0, to convert to a height above ground...
        ;; So make it the lower of the two.
CBW_1:		NEG
		ADD	A,$C0
        ;; Lower (increase Z coord) door height if it's a value less than A.
		LD	HL,DoorHeight
		CP	(HL)
		JR	C,CBW_2
		LD	(HL),A
        ;; Get door height into A and tail call BothWalls
CBW_2:		LD	A,(HL)
		JP	BothWalls	; NB: Tail call.