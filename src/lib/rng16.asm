; The random number generator from http://codebase64.org/doku.php?id=base:small_fast_16-bit_prng
random_number   .word 0

random_numer_generator_magic = $7263

next_random_number:
            lda random_number
            beq _low_zero 

            asl random_number
            lda random_number+1
            rol
            bcc _no_eor

_do_eor:
            eor #>random_numer_generator_magic
            sta random_number+1
            lda random_number
            eor #<random_numer_generator_magic
            sta random_number
            rts

_low_zero:
            lda random_number+1
            beq _do_eor
            asl
            beq _no_eor
            bcs _do_eor

_no_eor:
            sta random_number+1
            rts