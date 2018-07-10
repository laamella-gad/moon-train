                .section zp
MOVE_FROM       .addr ?
MOVE_TO         .addr ?
MOVE_SIZE       .word ?
                .send

bitpattern = [1,2,4,8,16,32,64,128]

poke16  .macro base, constant
        #poke \base, <\constant
        #poke \base+1, >\constant
        .endm

copy16  .macro source, dest
        #copy \source, \dest
        #copy \source+1, \dest+1
        .endm

poke    .macro base, constant
        lda #\constant
        sta \base
        .endm

copy    .macro source, dest
        lda \source
        sta \dest
        .endm

memcopy .macro source, dest, amount
        ldx #\amount-1
_more   lda \source, x
        sta \dest, x
        dex
        bpl _more
        .endm

memfill .macro value, dest, amount
        ldx #\amount
        lda #\value
_more   sta \dest-1, x
        dex
        bne _more
        .endm

; Move memory down
;
; FROM = source start address
;   TO = destination start address
; MOVE_SIZE = number of bytes to move
;
MOVEDOWN LDY #0
         LDX MOVE_SIZE +1
         BEQ MD2
MD1      LDA (MOVE_FROM),Y ; move a page at a time
         STA (MOVE_TO),Y
         INY
         BNE MD1
         INC MOVE_FROM+1
         INC MOVE_TO+1
         DEX
         BNE MD1
MD2      LDX MOVE_SIZE
         BEQ MD4
MD3      LDA (MOVE_FROM),Y ; move the remaining bytes
         STA (MOVE_TO),Y
         INY
         DEX
         BNE MD3
MD4      RTS
