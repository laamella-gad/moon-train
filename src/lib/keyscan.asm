; scan the keyboard
; result:
;   carry clear = no key hit
;   carry set = key in A
minikey:
    .block
	lda #%00000000
	sta $dc03	; port b ddr (input)
	lda #%11111111
	sta $dc02	; port a ddr (output)
			
	lda #%00000000
	sta $dc00	; port a
	lda $dc01       ; port b
	cmp #%11111111
	beq _nokey
	; got column, put it in Y
	tay
			
	lda #%01111111
	sta _nokey2+1
	ldx #8
_nokey2:
	lda #0
	sta $dc00	; port a
	
	sec
	ror _nokey2+1
	dex
	bmi _nokey
			
	lda $dc01       ; port b
	cmp #%11111111
	beq _nokey2
			
	; got row in X
	txa
	ora _columntab,y
			
	sec
	rts
			
_nokey:
	clc
	rts

_columntab:

    .for count=0, count<256, count+=1
		.if count = ($ff-$80)
			.byte $70
		.elsif count = ($ff-$40)
			.byte $60
		.elsif count = ($ff-$20)
			.byte $50
		.elsif count = ($ff-$10)
			.byte $40
		.elsif count = ($ff-$08)
			.byte $30
		.elsif count = ($ff-$04)
			.byte $20
		.elsif count = ($ff-$02)
			.byte $10
		.elsif count = ($ff-$01)
			.byte $00
		.else
			.byte $ff
		.endif
    .next
    .bend