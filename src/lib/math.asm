

add_byte_to_word    .macro addr, b
                    .block
                    ldx #$00    ; add_byte_to_word
                    lda \b
                    bpl b_positive
                    dex
b_positive          clc
                    adc \addr
                    sta \addr
                    txa
                    adc \addr+1
                    sta \addr+1
                    .bend
                    .endm

; adds numbers 1 and 2, writes result to res
add16   .macro num1, num2, res
	    clc				    ; add16
		lda \num1
		adc \num2
		sta \res
		lda \num1+1
		adc \num2+1
		sta \res+1
        .endm

; adds numbers 1 and 2, writes result to res
add16c  .macro num1, c, res
	    clc				    ; add16
		lda \num1
		adc #<\c
		sta \res
		lda \num1+1
		adc #>\c
		sta \res+1
        .endm

; subtracts number 2 from number 1 and writes result to res
sub16	.macro num1, num2, res
        sec				    ; sub16
		lda \num1
		sbc \num2
		sta \res
		lda \num1+1
		sbc \num2+1
		sta \res+1
		.endm

; subtracts number 2 from number 1 and writes result to res
sub16c	.macro num1, c, res
        sec				    ; sub16
		lda \num1
		sbc #<\c
		sta \res
		lda \num1+1
		sbc #>\c
		sta \res+1
		.endm

; beq will branch if both bytes are zero
is_zero_vect .macro vec
        .block
        lda \vec
        bne _done
        lda \vec+1
_done   .bend
        .endm

; reduces a vector by c
decvect	.macro num1, c
        .block
        #is_zero_vect \num1
        beq _done
        lda     \num1 ;decvect
        bmi     _negative_vect
_positive_vect
        #sub16c \num1, \c, \num1
        jmp     _done
_negative_vect
        #add16c \num1, \c, \num1
_done   .bend
		.endm

; Compare num1 and num2
; If the N flag is 1, then num1 (signed) <= num2 (signed) and BMI will branch
; If the N flag is 0, then num1 (signed) > num2 (signed) and BPL will branch
cmp16   .macro num1, num2
        .block
        LDA \num1           ; cmp16
        CMP \num2
        LDA \num1+1
        SBC \num2+1
        BVC _exit
        EOR #$80
_exit    .bend
        .endm

; Compare num1 and num2
; If the N flag is 1, then num1 (signed) <= num2 (signed) and BMI will branch
; If the N flag is 0, then num1 (signed) > num2 (signed) and BPL will branch
cmp16c  .macro num1, c
        .block
        LDA \num1           ; cmp16c
        CMP #<\c
        LDA \num1+1
        SBC #>\c
        BVC _exit
        EOR #$80
_exit    .bend
        .endm

signed_shr16    .macro addr ; signed_shr16
                lda \addr+1
                asl
                ror \addr+1
                ror \addr
                .endm

abs16   .macro addr
        .block
        ldx     \addr       ; abs16
        ; test hi byte
        cpx     #$00
        bpl     L1
        #neg16    \addr
L1      .bend
        .endm

absneg16 .macro addr
        .block
        ldx     \addr       ; absneg16
        cpx     #$00
        bmi     _L1
        #neg16    \addr
_L1      .bend
        .endm

neg16   .macro addr
        clc                 ; neg16
        lda     \addr
        eor     #$FF
        adc     #1
        sta     \addr
        lda     \addr+1
        eor     #$FF
        adc     #0
        sta     \addr+1
        .endm

nega    .macro
        clc
        eor     #$FF
        adc     #1
        .endm
