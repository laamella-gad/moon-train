                .enc "screen"

                .include "lib/segments.asm"

                v=VIC

lv              = SID_Amp
lw              = SID_Ctl[0]
lf              = SID_SLo[0]
hf              = SID_SHi[0]
a3              = SID_AD[0]
s3              = SID_SUR[0]
ph              = SID_PBHi[0]
pl              = SID_PBLo[0]

; ----------------------------------------------------------------------
                .section code
                #basic_sys_line start

start           JSR init
                #init_irq irq_handler, $F0
_loop           jmp _loop
                .send
; ----------------------------------------------------------------------

videomem_start  = $0000
screen_start    = $0400
                .include "lib/debug.asm"
                .include "lib/irq.asm"
                .include "lib/video.asm"
                .include "lib/memory.asm"
                .include "lib/math.asm"
                .include "lib/keyscan.asm"
                .include "lib/rng16.asm"
                .include "score.asm"


; ----------------------------------------------------------------------
                .section code
spritestruct    .struct
x               .byte 0
y               .byte 0
box
box_xoffs       .byte 0
box_yoffs       .byte 0
box_w           .byte 24
box_h           .byte 21
                .ends

playersprite            .dstruct spritestruct
playerbulletsprite      .dstruct spritestruct
alien1sprite            .dstruct spritestruct
alien2sprite            .dstruct spritestruct
alien1bulletsprite      .dstruct spritestruct
alien2bulletsprite      .dstruct spritestruct
explosionlsprite        .dstruct spritestruct
explosionrsprite        .dstruct spritestruct
sprite                  = [ playersprite,
                            playerbulletsprite,
                            alien1sprite,
                            alien2sprite,
                            alien1bulletsprite,
                            alien2bulletsprite,
                            explosionlsprite,
                            explosionrsprite]

                ; box = x offset into sprite, y offset into sprite, width, height
alienbox        .byte 0/2, 0, 24/2, 21
playerbox       .byte 2*2/2, 9*2, (24-2)*2/2, (21-9)*2
bulletbox       .byte 6*2/2, 0*2, 2*2/2, 21*2

trainspeed      = 2
stone_start_x   = 29
; ----------------------------------------------------------------------
init:           #spritecopy train_sprite_data, 13
                #spritecopy bullet_sprite_data, 15
                #spritecopy alien_sprite_data, 11
                #spritecopy ramt_l_sprite_data, 9
                #spritecopy ramt_r_sprite_data, 10

                #poke16 HIGH_SCORE_LOCATION, screen_loc(9,23)
                #poke16 SCORE_LOCATION, screen_loc(25,23)
                jsr reset_score

                #memcopy playerbox, playersprite.box, 4
                #memcopy alienbox, alien1sprite.box, 4
                #memcopy alienbox, alien2sprite.box, 4
                #memcopy bulletbox, playerbulletsprite.box, 4
                #memcopy bulletbox, alien1bulletsprite.box, 4
                #memcopy bulletbox, alien2bulletsprite.box, 4

                jsr init_title
;                jsr init_game

                rts
; mode
GAME_MODE       = 1
TITLE_MODE      = 0
mode            .byte $FF

; ----------------------------------------------------------------------
irq_handler:
                lda mode
                sta $d020
                bne _game
                jsr title
                jmp _done
_game           jsr game


_done
                jsr next_random_number
                lda #$0F
                sta $d020
                rts
; ----------------------------------------------------------------------
init_title:
                #poke mode, TITLE_MODE

                #cls COLOR_BLACK, COLOR_BLACK, COLOR_YELLOW
                #poke v+21,0

                jsr music_player_init

                #poke16 MOVE_FROM, intro_screen
                #poke16 MOVE_TO, screen_start
                #poke16 MOVE_SIZE, 1000
                jsr MOVEDOWN

                rts

; ----------------------------------------------------------------------
title:
                jsr music_player
                jsr minikey
                cmp #$47
                beq init_game
                rts
; ----------------------------------------------------------------------
status_bar:     .null " hi.sco:         points:         liv: - "
init_game:
                #poke mode, GAME_MODE

                #cls COLOR_BLACK, COLOR_BLACK, COLOR_LIGHT_GRAY

                ; kill music
                #poke lw,0

                ;
                #poke VIC_SPR_COLOR[0],COLOR_YELLOW
                #poke VIC_SPR_COLOR[1],COLOR_WHITE
                #poke VIC_SPR_COLOR[6],COLOR_PINK
                #poke VIC_SPR_COLOR[7],COLOR_PINK
                ; sprite images
                #poke VIC_SPR_PTR[0],13 ; player
                #poke VIC_SPR_PTR[1],15 ; player bullet
                #poke VIC_SPR_PTR[2],11 ; alien 1
                #poke VIC_SPR_PTR[3],11 ; alien 2
                #poke VIC_SPR_PTR[4],15 ; alien 1 bullet
                #poke VIC_SPR_PTR[5],15 ; alien 2 bullet
                #poke VIC_SPR_PTR[6],9  ; explosion left
                #poke VIC_SPR_PTR[7],10 ; explosion right
                ;
                #poke VIC_SPR_EXP_Y,%00110011
                #poke VIC_SPR_EXP_X,%00110011
                #poke VIC_SPR_TO_BG,0
                ; sprites enabled
                #poke VIC_SPR_ENA,%11111111
                ; train position
                #poke playersprite.x,100
                #poke playersprite.y,175
                ; bullet positions (x=0 means not active)
                #poke playerbulletsprite.x,0
                #poke playerbulletsprite.y,0
                #poke alien1bulletsprite.x,0
                #poke alien1bulletsprite.y,0
                #poke alien2bulletsprite.x,0
                #poke alien2bulletsprite.y,0
                ; alien position
                #poke alien1sprite.y,60
                #poke alien2sprite.y,60

                ; Ground
                #memfill ' '+$80, screen_loc(0,21), 40
                #memcopy status_bar, screen_loc(0,23), 40

                ; lives
                #poke lives, '5'

                ; bonus threshold
                #poke bp+0, $00
                #poke bp+1, $30
                #poke bp+2, $00

                ; stone
                #poke tr, 10
                #poke tr_ctr, 10
                #poke sp, stone_start_x

                ; jump
                #poke jump_ctr, 0

                jsr reset_score

                rts
; ----------------------------------------------------------------------
; stone speed
tr              .byte 10
tr_ctr          .byte 10
; stone position
sp              .byte 29
lives           .byte 0

; alien shoot locations
m               .byte 100
n               .byte 150

; amount of points to start bonus ceremony
bp              .byte $00, $30, $00


jump_ctr        .byte 0
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
game:
                jsr display_score
                jsr display_high_score
                jsr display_lives
                jsr update_stone
                jsr check_joystick
                jsr update_jump
                jsr update_player_bullet
                jsr update_aliens
                jsr update_alien_bullets
                jsr update_explosion
                jsr check_player_bullet_alien_collision
                jsr check_alien_bullet_player_collision
                jsr check_ground_collision

                jsr update_coordinates
                rts
; ----------------------------------------------------------------------
check_joystick:
_joy_up:        lda #%00000001
                bit $dc00
                bne _joy_left
                jsr player_start_jump

_joy_left:      lda #%00000100
                bit $dc00
                bne _joy_right
                jsr player_left

_joy_right:     lda #%00001000
                bit $dc00
                bne _joy_fire
                jsr player_right

_joy_fire:      lda #%00010000
                bit $dc00
                bne _done
                jsr fire_player_bullet
_done:          rts
; ----------------------------------------------------------------------
update_coordinates:
                .for spr=0, spr<=7, spr+=1
                ; Y
                lda sprite[spr].y
                sta VIC_SPR_Y[spr]
                ; X
                lda sprite[spr].x
                asl
                ror VIC_SPR_HI_X
                sta VIC_SPR_X[spr]
                .next
                rts
; ----------------------------------------------------------------------
update_stone:
                ; stone movement delay
                dec tr_ctr
                bne _done
                lda tr
                sta tr_ctr
                ; clear old position
                ldx sp
                lda #' '
                sta screen_loc(0,20), x
                ; move
                inx
                cpx #40
                bcc _no_stone_reset
                ; re-enter at left of screen
                ldx #0
_no_stone_reset:
                ; set new position
                lda #'●'
                sta screen_loc(0,20), x
                stx sp
_done:
                rts
; ----------------------------------------------------------------------
player_start_jump:
                lda jump_ctr
                bne _done
                #poke jump_ctr, 20
                #poke playersprite.y, 150
                ; jump sound
                #poke lv,15
                #poke lw,33
                #poke hf,40
                #poke lf,200
                #poke a3,15
_done:
                rts
; ----------------------------------------------------------------------
update_jump:
                lda jump_ctr
                beq _done
                dec jump_ctr
                bne _done
                #poke playersprite.y, 175
                jsr stop_sound
_done:
                rts
; ----------------------------------------------------------------------
player_left:
                lda playersprite.x
                sec
                sbc #trainspeed
                cmp #13
                bcs _not_at_left_side_of_screen
                lda #13
_not_at_left_side_of_screen:
                sta playersprite.x
                rts
; ----------------------------------------------------------------------
player_right:
                lda playersprite.x
                clc
                adc #trainspeed
                cmp #148
                bcc _not_at_right_side_of_screen
                lda #148
_not_at_right_side_of_screen:
                sta playersprite.x
                rts
; ----------------------------------------------------------------------
fire_player_bullet:
                lda playerbulletsprite.x
                bne _done
                sec
                lda playersprite.x
                sta playerbulletsprite.x
                lda playersprite.y
                sbc #37-5
                sta playerbulletsprite.y
                jsr play_fire_sound
_done:
                rts
; ----------------------------------------------------------------------
explosion_x:    .byte 0
explosion_y:    .byte 0
explosion:
                lda explosion_x
                sta explosionlsprite.x
                clc
                adc #12
                sta explosionrsprite.x
                lda explosion_y
                sta explosionlsprite.y
                sta explosionrsprite.y
                rts
; ----------------------------------------------------------------------
update_explosion:
                lda explosionlsprite.x
                cmp #10
                bcc _left_off_screen
                sec
                sbc #4
                sta explosionlsprite.x
                jmp _right_part
_left_off_screen:
                lda #0
                sta explosionlsprite.x
_right_part:
                lda explosionrsprite.x
                cmp #175
                bcs _right_off_screen
                clc
                adc #4
                sta explosionrsprite.x
                rts
_right_off_screen:
                lda #175
                sta explosionrsprite.x

                rts
; ----------------------------------------------------------------------
check_player_bullet_alien_collision:
                lda playerbulletsprite.x
                bne _alien1
                rts

_alien1:
                #check_collision playerbulletsprite, alien1sprite
                bcc _alien2

                lda alien1sprite.x
                sbc #6
                sta explosion_x
                #copy alien1sprite.y, explosion_y
                jsr explosion

                lda #0
                sta alien1sprite.x
                jsr add_score
_alien2:
                #check_collision playerbulletsprite, alien2sprite
                bcc _done

                lda alien2sprite.x
                sbc #6
                sta explosion_x
                #copy alien2sprite.y, explosion_y
                jsr explosion

                lda #0
                sta alien2sprite.x
                jsr add_score

_done:
                rts
; ----------------------------------------------------------------------
check_alien_bullet_player_collision:

_alien1:
                lda alien1bulletsprite.x
                beq _alien2
                #check_collision alien1bulletsprite, playersprite
                bcc _alien2
                ; hit by alien 1
                #copy alien1bulletsprite.x, explosion_x
                lda alien1bulletsprite.y
                clc
                adc #20
                sta explosion_y
                jsr explosion
                jsr player_hit

                lda #0
                sta alien1bulletsprite.x
                sta alien2bulletsprite.x
_alien2:
                lda alien2bulletsprite.x
                beq _done
                #check_collision alien2bulletsprite, playersprite
                bcc _done
                ; hit by alien 2
                #copy alien2bulletsprite.x, explosion_x
                lda alien2bulletsprite.y
                clc
                adc #20
                sta explosion_y
                jsr explosion
                jsr player_hit

                lda #0
                sta alien1bulletsprite.x
                sta alien2bulletsprite.x

_done:
                rts
; ----------------------------------------------------------------------
check_collision_tmp: .byte 0
check_collision:.macro spr_a, spr_b
                .block
_check_x:
                lda \spr_a + spritestruct.x
                clc
                adc \spr_a + spritestruct.box_xoffs
                sec
                sbc \spr_b + spritestruct.x
                sbc \spr_b + spritestruct.box_xoffs

                bmi _b_to_the_left_of_a

_b_to_the_right_of_a:
                cmp \spr_b + spritestruct.box_w
                bcs _no_collision
                jmp _check_y

_b_to_the_left_of_a:
                #nega
                cmp \spr_a + spritestruct.box_w
                bcs _no_collision

_check_y:
                lda \spr_a + spritestruct.y
                clc
                adc \spr_a + spritestruct.box_yoffs
                sec
                sbc \spr_b + spritestruct.y
                sbc \spr_b + spritestruct.box_yoffs

                bmi _b_above_a
_b_below_a:
                cmp \spr_b + spritestruct.box_h
                bcs _no_collision
                jmp _collision

_b_above_a:
                #nega
                cmp \spr_a + spritestruct.box_h
                bcs _no_collision

_collision:
                sec
                jmp _done
_no_collision:
                clc
_done:
                .bend
                .endm
; ----------------------------------------------------------------------
player_hit:
                ; reset stone
                lda #' '
                ldx sp
                sta screen_loc(0,20), x
                #poke sp, stone_start_x

                ; lives = lives - 1
                dec lives
                lda lives
                cmp #'0'
                bcc game_over
                rts
game_over:
                jsr update_high_score
                jsr init_title
                rts
; ----------------------------------------------------------------------
check_ground_collision:
                ; are we jumping?
                lda jump_ctr
                bne _done

                lda playersprite.x
                sec
                sbc #8
                lsr
                lsr
                tax
                ldy #5
_rep:
                lda screen_loc(0,20), x
                cmp #' '
                bne _collision
                inx
                dey
                bne _rep
_done:
                rts
_collision:
                #copy playersprite.x, explosion_x
                lda playersprite.y
                clc
                adc #20
                sta explosion_y
                jsr explosion
                jsr player_hit
                rts
; ----------------------------------------------------------------------
play_fire_sound:
                #poke lv,15
                #poke lw,129
                #poke hf,40
                #poke lf,200
                #poke a3,15
                rts
; ----------------------------------------------------------------------
update_player_bullet:
                lda playerbulletsprite.x
                bne _move_bullet
                rts

_move_bullet:   lda playerbulletsprite.y
                cmp #200
                bcs _stop_bullet
                sec
                sbc #5
                sta playerbulletsprite.y
                rts
_stop_bullet:
                lda #0
                sta playerbulletsprite.x
                sta playerbulletsprite.y
                jsr stop_sound
                rts
; ----------------------------------------------------------------------
stop_sound:
                #poke lw,0
                #poke lv,0
                rts
; ----------------------------------------------------------------------
update_aliens:
; alien 1
                lda alien1sprite.x
                clc
                adc #1
                cmp #172
                bcc _alien_1_on_screen
                lda #0
_alien_1_on_screen:
                sta alien1sprite.x

; alien 2
                lda alien2sprite.x
                sec
                sbc #2
                cmp #4
                bcs _alien_2_on_screen
                lda #172
_alien_2_on_screen:
                sta alien2sprite.x

                lda random_number
                cmp #$FF
                beq _fire_alien_1_bullet
                cmp #$EE
                beq _fire_alien_2_bullet
                rts

_fire_alien_1_bullet:
                #_fire_alien_bullet 2, 4
                rts

_fire_alien_2_bullet:
                #_fire_alien_bullet 3, 5
                rts

_fire_alien_bullet: .macro alien_spr, bullet_spr
                lda sprite[\bullet_spr].x
                beq _bullet_available
                rts
_bullet_available:
                ldx sprite[\alien_spr].x
                dex
                stx sprite[\bullet_spr].x
                ldy #70
                sty sprite[\bullet_spr].y
                jsr play_fire_sound
                .endm
; ----------------------------------------------------------------------
update_alien_bullets:
                #_update_alien_bullet 4
                #_update_alien_bullet 5
                rts

_update_alien_bullet: .macro spr
                .block
                lda sprite[\spr].x
                beq _done
                ; bullet is active
                lda sprite[\spr].y
                cmp #175
                bcs _stop_bullet
                clc
                adc #1
                sta sprite[\spr].y
                jmp _done
_stop_bullet:
                lda #0
                sta sprite[\spr].x
                sta sprite[\spr].y
                jsr stop_sound
_done:
                .bend
                .endm

; ----------------------------------------------------------------------
display_lives:
                lda lives
                sta screen_loc(38,23)
                rts
; ----------------------------------------------------------------------
note_pointer    .byte 0
note_delay      .byte 0

music_player_init:
                #poke lv,15
                #poke ph,15
                #poke pl,15
                #poke a3,$08
                #poke s3,$80
                #poke note_pointer, 0
                #poke note_delay, 0
                rts

music_player:   lda note_delay
                beq _next_note
                cmp #2
                bne _no_note_off
                ; note off
                #poke lw,0
_no_note_off:   dec note_delay
                rts

_next_note:     ldx note_pointer
                lda music_data, x
                bne _play_note
                lda #0
                sta note_pointer
                rts

_play_note:     sta hf
                inx
                lda music_data, x
                sta lf
                #poke lw,33
                inx
                lda music_data, x
                sta note_delay
                inx
                stx note_pointer
                rts

music_data:
                .byte   8,147,10
                .byte  17, 37,10
                .byte  34, 75,10
                .byte  68,149,10
                .byte 137, 43,10
                .byte 244,103,10
                .byte  34, 75,10
                .byte 244,103,10
                .byte  68,149,10
                .byte 244,103,10
                .byte  68,149,10
                .byte  34, 75,10
                .byte  17, 37,10
                .byte   8,147,10
                .byte   0,  0,0

                .union
                .binary "sprites.bin"
                .struct
train_sprite_data: .fill 64
bullet_sprite_data: .fill 64
alien_sprite_data: .fill 64
ramt_l_sprite_data: .fill 64
ramt_r_sprite_data: .fill 64
                .ends
                .endu

intro_screen:   .binary "title.bin"
                .send
