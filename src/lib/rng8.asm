; The random number generator from http://codebase64.org/doku.php?id=base:small_fast_8-bit_prng
random_number   .byte 0

next_random_number:
            lda random_number
            beq _do_eor
            asl
            beq _no_eor ;if the input was $80, skip the EOR
            bcc _no_eor
_do_eor:    eor #$1d
_no_eor:    sta random_number
            rts