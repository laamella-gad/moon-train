debug           = true

borderdebug     .macro
                .if debug
                inc $d020
                .fi
                .endm

borderdebug_b   .macro
                .if debug
                ldx $d020
                lda #1
                sta $d020
                stx $d020
                .fi
                .endm

borderdebug_a   .macro
                .if debug
                sta $d020
                .fi
                .endm

debug16     .macro col, row, data
            .if debug
             #poke 1024+\col*2+\row*40, \data+1
             #poke 1024+\col*2+\row*40+1, \data
            .fi
            .endm

; ----------------------------------------------------------------------
hex_digits:     .text "0123456789abcdef"
printhex:       .macro loc
                pha
                pha
                and #$0F
                tax
                lda hex_digits, x
                sta \loc+1
                pla
                lsr
                lsr
                lsr
                lsr
                tax
                lda hex_digits, x
                sta \loc
                pla
                .endm
