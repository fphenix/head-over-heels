	;; FIXME: Want to move from explicit refs to labels
	;; everywhere, and this is a grim step along the way.

L0000:	EQU $0000
L0001:	EQU $0001
L0002:	EQU $0002
L0003:	EQU $0003
L0004:	EQU $0004
L0005:	EQU $0005
L0006:	EQU $0006
L0007:	EQU $0007
L0008:	EQU $0008
L0009:	EQU $0009
L000A:	EQU $000A
L000B:	EQU $000B
L0010:	EQU $0010
L0012:	EQU $0012
L0018:	EQU $0018
L0020:	EQU $0020
L0024:	EQU $0024
L0030:	EQU $0030
L0040:	EQU $0040
L0043:	EQU $0043
L0048:	EQU $0048
L0060:	EQU $0060
L0070:	EQU $0070
L0094:	EQU $0094
L00A8:	EQU $00A8
L00F8:	EQU $00F8
L00FE:	EQU $00FE
L00FF:	EQU $00FF
L0100:	EQU $0100
L0104:	EQU $0104
L012D:	EQU $012D
L0150:	EQU $0150
L01F4:	EQU $01F4
L027C:	EQU $027C
L0401:	EQU $0401
L040F:	EQU $040F
L0501:	EQU $0501
L05FF:	EQU $05FF
L0606:	EQU $0606
L0804:	EQU $0804
L0808:	EQU $0808
L080C:	EQU $080C
L091B:	EQU $091B
L0D00:	EQU $0D00
L0D70:	EQU $0D70
L0D7C:	EQU $0D7C
L1002:	EQU $1002
L1004:	EQU $1004
L1800:	EQU $1800
L180C:	EQU $180C
L181F:	EQU $181F
L184D:	EQU $184D
L1B21:	EQU $1B21
L390C:	EQU $390C
L4048:	EQU $4048
L4857:	EQU $4857
L523E:	EQU $523E
L569A:	EQU $569A
L5C71:	EQU $5C71
L6088:	EQU $6088
L6B16:	EQU $6B16
L7FFD:	EQU $7FFD 		; Numeric constant

	;; References into code area.
L822D:	EQU $822D
L822E:	EQU $822E
L8264:	EQU $8264
L8406:	EQU $8406
L84C5:	EQU $84C5
L84C7:	EQU $84C7
L84C8:	EQU $84C8
L84C9:	EQU $84C9
L84CA:	EQU $84CA
L84E4:	EQU $84E4
L8592:	EQU $8592
L866C:	EQU $866C
L8728:	EQU $8728
L874F:	EQU $874F
L8763:	EQU $8763
L87D1:	EQU $87D1
L8805:	EQU $8805
L8827:	EQU $8827
L8855:	EQU $8855
L88EF:	EQU $88EF
L8940:	EQU $8940
L895E:	EQU $895E
L8A04:	EQU $8A04
L8A09:	EQU $8A09
L8A40:	EQU $8A40
L8ADC:	EQU $8ADC
L8ADF:	EQU $8ADF
L8D18:	EQU $8D18
L8D49:	EQU $8D49
L8DED:	EQU $8DED
L8E0E:	EQU $8E0E
L8ECF:	EQU $8ECF
L8ED9:	EQU $8ED9
L8EDA:	EQU $8EDA
L940B:	EQU $940B
L9C16:	EQU $9C16
L9C8C:	EQU $9C8C
L9C98:	EQU $9C98
L9CA0:	EQU $9CA0
L9CD2:	EQU $9CD2
L9CF6:	EQU $9CF6
L9CF7:	EQU $9CF7
L9CFC:	EQU $9CFC
L9D03:	EQU $9D03
L9D04:	EQU $9D04
L9D19:	EQU $9D19
L9D2F:	EQU $9D2F
L9D62:	EQU $9D62
L9DF8:	EQU $9DF8
L9F25:	EQU $9F25
L9F30:	EQU $9F30
L9F40:	EQU $9F40
L9FC3:	EQU $9FC3
L9FFB:	EQU $9FFB
LA12B:	EQU $A12B
LA19F:	EQU $A19F
LA355:	EQU $A355
LA361:	EQU $A361
LA700:	EQU $A700
LA712:	EQU $A712
LA800:	EQU $A800
LA88F:	EQU $A88F
LAA42:	EQU $AA42
LAA6E:	EQU $AA6E
LAA72:	EQU $AA72
LAA73:	EQU $AA73
LABE7:	EQU $ABE7
LACCC:	EQU $ACCC
LADA4:	EQU $ADA4
LB67E:	EQU $B67E
LB67F:	EQU $B67F
LB680:	EQU $B680
LB681:	EQU $B681
LB683:	EQU $B683
LB747:	EQU $B747

	;; Data-ish stuff
LB884:	EQU $B884
LB900:	EQU $B900
LBA00:	EQU $BA00
LBA3E:	EQU $BA3E
LBF20:	EQU $BF20
LC000:	EQU $C000
LC038:	EQU $C038
LC040:	EQU $C040
LC043:	EQU $C043
LC0C0:	EQU $C0C0
LC1A0:	EQU $C1A0
LC910:	EQU $C910
LCBB0:	EQU $CBB0
LCD30:	EQU $CD30
LCF3E:	EQU $CF3E
LD12D:	EQU $D12D
LD8B0:	EQU $D8B0
LEB90:	EQU $EB90
LF610:	EQU $F610
LF670:	EQU $F670
LF760:	EQU $F760
LF790:	EQU $F790
LF91B:	EQU $F91B
LF91D:	EQU $F91D
LF933:	EQU $F933
LF943:	EQU $F943
LF9D7:	EQU $F9D7
LF9D8:	EQU $F9D8
LFA80:	EQU $FA80
LFB28:	EQU $FB28
LFB49:	EQU $FB49
LFEFE:	EQU $FEFE
LFFEE:	EQU $FFEE
LFFF5:	EQU $FFF5
LFFFA:	EQU $FFFA
LFFFE:	EQU $FFFE
LFFFF:	EQU $FFFF
