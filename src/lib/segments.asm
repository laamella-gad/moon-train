*       = $02
        .dsection zp
        .cerror * > $FF, "Too many zero page variables"

*       = $0801
        .dsection code
        .cerror * > $CFFF, "Program too long!"
