;
; C64 generic definitions. Stolen from Elite128
;


; ---------------------------------------------------------------------------
; Vector and other locations

IRQVec          = $0314
BRKVec          = $0316
NMIVec          = $0318

; ---------------------------------------------------------------------------
; Screen size

XSIZE           = 40
YSIZE           = 25

; ---------------------------------------------------------------------------
; I/O: VIC

VIC             = $D000
VIC_SPR_X       = [$D000, $D002, $D004, $D006, $D008, $D00A, $D00C, $D00E]
VIC_SPR_Y       = [$D001, $D003, $D005, $D007, $D009, $D00B, $D00D, $D00F]
VIC_SPR_HI_X    = $D010
VIC_SPR_ENA     = $D015
VIC_SPR_EXP_Y   = $D017
VIC_SPR_EXP_X   = $D01D
VIC_SPR_MCOLOR  = $D01C
VIC_SPR_BG_PRIO = $D01B

VIC_SPR_MCOLOR0 = $D025
VIC_SPR_MCOLOR1 = $D026

VIC_SPR_COLOR   = [$D027, $D028, $D029, $D02A, $D02B, $D02C, $D02D, $D02E]

VIC_SPR_TO_SPR  = $D01E
VIC_SPR_TO_BG   = $D01F

VIC_CTRL1       = $D011
VIC_CTRL2       = $D016

VIC_HLINE       = $D012

VIC_VIDEO_ADR   = $D018

VIC_IRR         = $D019        ; Interrupt request register
VIC_IMR         = $D01A        ; Interrupt mask register

VIC_BORDERCOLOR = $D020
VIC_BG_COLOR0   = $D021
VIC_BG_COLOR1   = $D022
VIC_BG_COLOR2   = $D023
VIC_BG_COLOR3   = $D024

; ---------------------------------------------------------------------------
; I/O: SID

SID             = $D400

SID_SLo         = [$D400, $D407, $D40E]
SID_SHi         = [$D401, $D408, $D40F]
SID_PBLo        = [$D402, $D409, $D410]
SID_PBHi        = [$D403, $D40A, $D411]
SID_Ctl         = [$D404, $D40B, $D412]
SID_AD          = [$D405, $D40C, $D413]
SID_SUR         = [$D406, $D40D, $D414]

SID_FltLo       = $D415
SID_FltHi       = $D416
SID_FltCtl      = $D417
SID_Amp         = $D418
SID_ADConv1     = $D419
SID_ADConv2     = $D41A
SID_Noise       = $D41B
SID_Read3       = $D41C

; ---------------------------------------------------------------------------
; I/O: VDC (128 only)

VDC_INDEX       = $D600
VDC_DATA        = $D601

; ---------------------------------------------------------------------------
; I/O: Complex Interface Adapters

CIA1            = $DC00
CIA1_PRA        = $DC00        ; Port A
CIA1_PRB        = $DC01        ; Port B
CIA1_DDRA       = $DC02        ; Data direction register for port A
CIA1_DDRB       = $DC03        ; Data direction register for port B
CIA1_TA         = $DC04        ; 16-bit timer A
CIA1_TB         = $DC06        ; 16-bit timer B
CIA1_TOD10      = $DC08        ; Time-of-day tenths of a second
CIA1_TODSEC     = $DC09        ; Time-of-day seconds
CIA1_TODMIN     = $DC0A        ; Time-of-day minutes
CIA1_TODHR      = $DC0B        ; Time-of-day hours
CIA1_SDR        = $DC0C        ; Serial data register
CIA1_ICR        = $DC0D        ; Interrupt control register
CIA1_CRA        = $DC0E        ; Control register for timer A
CIA1_CRB        = $DC0F        ; Control register for timer B

CIA2            = $DD00
CIA2_PRA        = $DD00
CIA2_PRB        = $DD01
CIA2_DDRA       = $DD02
CIA2_DDRB       = $DD03
CIA2_TA         = $DD04
CIA2_TB         = $DD06
CIA2_TOD10      = $DD08
CIA2_TODSEC     = $DD09
CIA2_TODMIN     = $DD0A
CIA2_TODHR      = $DD0B
CIA2_SDR        = $DD0C
CIA2_ICR        = $DD0D
CIA2_CRA        = $DD0E
CIA2_CRB        = $DD0F

; ---------------------------------------------------------------------------
; Processor Port at $01

LORAM           = $01           ; Enable the basic rom
HIRAM           = $02           ; Enable the kernal rom
IOEN            = $04           ; Enable I/O
CASSDATA        = $08           ; Cassette data
CASSPLAY        = $10           ; Cassette: Play
CASSMOT         = $20           ; Cassette motor on

RAMONLY         = $F8           ; (~(LORAM | HIRAM | IOEN)) & $FF

basic_sys_line  .macro start_addr
; BASIC SYS line
*               = $0801
                .word (+), $ffff                 ;pointer, line number
                .null $9e, format("%d", \start_addr)  ;will be sys 4096
+	            .word 0                         ;basic line end
                .endm
