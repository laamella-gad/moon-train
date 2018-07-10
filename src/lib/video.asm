.include        "c64.asm"

colormem_start  = $D800
vic_spr_img     = [ videomem_start + $03F8 + 0, videomem_start + $03F8 + 1, videomem_start + $03F8 + 2, videomem_start + $03F8 + 3, videomem_start + $03F8 + 4, videomem_start + $03F8 + 5,videomem_start + $03F8 + 6, videomem_start + $03F8 + 7]

;videomem_start  = $4000
;screen_start    = videomem_start

cls     .macro  fg, bg, color
        lda #\bg
        sta $d020
        lda #\fg
        sta $d021
        ldx #0
_loop   lda #$20
        sta screen_start+$0000,x
        sta screen_start+$0100,x
        sta screen_start+$0200,x
        sta screen_start+$02e8,x
        lda #\color
        sta colormem_start+$0000,x
        sta colormem_start+$0100,x
        sta colormem_start+$0200,x
        sta colormem_start+$02e8,x
        dex
        bne _loop
        .endm

spritecopy      .macro data, sprite_nr
                #memcopy \data, videomem_start+\sprite_nr*64, 63
                .endm

COLOR_BLACK     = 0
COLOR_WHITE     = 1
COLOR_RED       = 2
COLOR_CYAN      = 3
COLOR_PURPLE    = 4
COLOR_GREEN     = 5
COLOR_BLUE      = 6
COLOR_YELLOW    = 7
COLOR_ORANGE    = 8
COLOR_BROWN     = 9
COLOR_PINK      = 10
COLOR_DARK_GRAY = 11
COLOR_GRAY      = 12
COLOR_LIGHT_GREEN=13
COLOR_LIGHT_BLUE= 14
COLOR_LIGHT_GRAY= 15

VIC_SPR_PTR     = [screen_start+$3F8, screen_start+$3F9, screen_start+$3FA, screen_start+$3FB, screen_start+$3FC, screen_start+$3FD, screen_start+$3FE, screen_start+$3FF]

screen_loc      .function x, y
                .endf screen_start+x+40*y
