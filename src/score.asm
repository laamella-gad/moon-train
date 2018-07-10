; Handles a 3-byte BCD score that can be added to,
; and a 3-byte BCD high score that can be set.

SCORE           .byte 0,0,0
HIGH_SCORE      .byte $34,$12,0
SCORE_ADD       .byte 0,$01,0
                .section zp
SCORE_COMPARE   .addr ?
                .send

                .section zp
SCORE_LOCATION  .addr ?
HIGH_SCORE_LOCATION .addr ?
                .send

; Set the score to 0
reset_score:
                lda #0
                sta SCORE+0
                sta SCORE+1
                sta SCORE+2
                rts

; Add SCORE_ADD to SCORE
add_score:
                sed
                clc
                lda SCORE+0
                adc SCORE_ADD+0
                sta SCORE+0
                lda SCORE+1
                adc SCORE_ADD+1
                sta SCORE+1
                lda SCORE+2
                adc SCORE_ADD+2
                sta SCORE+2
                cld
                rts

; Displays the score
display_score:  #display_bcd SCORE, SCORE_LOCATION
                rts

display_high_score:
                #display_bcd HIGH_SCORE, HIGH_SCORE_LOCATION
                rts

update_high_score:
                lda #>HIGH_SCORE
                sta SCORE_COMPARE+1
                lda #<HIGH_SCORE
                sta SCORE_COMPARE
                jsr score_higher_than
                bcs _update
                rts
_update:
                lda SCORE
                sta HIGH_SCORE
                lda SCORE+1
                sta HIGH_SCORE+1
                lda SCORE+2
                sta HIGH_SCORE+2
                rts

; When SCORE > SCORE_COMPARE then C=0
; When SCORE <= SCORE_COMPARE then C=1
score_higher_than:
_digit2:
                lda SCORE+2
                ldy #2
                cmp (SCORE_COMPARE), y
                beq _digit1
                rts
_digit1:
                lda SCORE+1
                ldy #1
                cmp (SCORE_COMPARE), y
                beq _digit0
                rts
_digit0:
                lda SCORE+0
                ldy #0
                cmp (SCORE_COMPARE), y
                rts

;
display_bcd:    .macro number, screen_location
                clc
                ldx #2
                ldy #0
_digit:         lda \number, x
                pha
                lsr
                lsr
                lsr
                lsr
                clc
                adc #$30
                sta (\screen_location), y
                iny
                pla
                and #%00001111
                adc #$30
                sta (\screen_location), y
                iny
                dex
                bpl _digit
                .endm
