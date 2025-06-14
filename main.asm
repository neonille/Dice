    processor 6502
    include "vcs.h"
    org $f000

pfrow = $80
diceGrPt = $81
fireflag = $83
state = $84
rolltimer = $85
seed = $ff
diceroll = $90
timer = 50


start:
    sei
    ldx #seed
    ldy seed
    txs
    lda #0
clear:
    sta 0,x
    dex
    bne clear
    sty $ff

    lda #$00
    sta colubk

    lda #$0e
    sta colupf

    lda #1
    sta ctrlpf

    lda #2
    sta diceroll

    lda #0
    sta state

    lda #timer
    sta rolltimer

        ; Sound
    lda #2         ; set a waveform (4 = square wave)
    sta audc0

    lda #4        ; set frequency (0–31, lower = higher pitch)
    sta audf0
    
sync:
    lda #2
    sta vsync
    sta wsync
    sta wsync
    sta wsync
    lda #0
    sta vsync

    lda state
    bne nopress

    lda inpt4
    bmi nopress

    ; Roll the dice
rolldice:
    lda seed
    asl
    bcc notaps
    eor #$1d
notaps:
    sta seed

    and #%00000111
    tax
    dex
    dex
    bmi rolldice
    inx
    stx diceroll
    
    lda #2
    sta state

nopress:
    lda #0
    sta wsync

    lda #69
    sta pfrow

    ldx #192
    ldy #1
    ; Set graphics for dice
    lda diceroll
    sec
    sbc #1
    asl
    tay
    lda bytemap,y
    sta diceGrPt
    lda bytemap,y+1
    sta diceGrPt+1

rendertop:
    ldx #37
top:
    sta wsync
    dex
    bne top
    lda #0
    sta vblank

    lda state
    bne render2

    lda #69
    sta pfrow

render1:
    lda #0
    sta audv0
    ; y = Only update pf every 8'th scanline
    ldx #192
    ldy #1
visible:
    sta wsync
    dey
    beq updatePf
donepf:
    dex
    bne visible



renderbottom:
    lda #2
    sta vblank
    ldx #30
bottom:
    sta wsync
    dex
    bne bottom

    jmp sync

updatePf:
    ldy pfrow
    lda (diceGrPt),y
    sta pf0
    dey
    lda (diceGrPt),y
    sta pf2
    dey
    lda (diceGrPt),y
    sta pf1
    dey
    sty pfrow

    ldy #9
    jmp donepf

render2:
    lda #5        ; set volume (0–15)
    sta audv0

    lda rolltimer
    sec
    sbc #1
    sta rolltimer
    bne nostatechange
    lda #0
    sta state
    lda #timer
    sta rolltimer
nostatechange:
    ldx #192
visible2:
    sta wsync
    dex
    bne visible2
    jmp renderbottom


bytemap:
    .word one
    .word two
    .word three
    .word four
    .word five
    .word six

one:
    .byte $00,$00,$00 ;|                    | ( 0)
    .byte $00,$00,$00 ;|                    | ( 1)
    .byte $00,$00,$00 ;|                    | ( 2)
    .byte $00,$00,$00 ;|                    | ( 3)
    .byte $00,$00,$00 ;|                    | ( 4)
    .byte $00,$00,$00 ;|                    | ( 5)
    .byte $00,$00,$FF ;|            XXXXXXXX| ( 6)
    .byte $00,$00,$01 ;|            X       | ( 7)
    .byte $00,$00,$01 ;|            X       | ( 8)
    .byte $00,$00,$01 ;|            X       | ( 9)
    .byte $00,$00,$01 ;|            X       | (10)
    .byte $00,$00,$81 ;|            X      X| (11)
    .byte $00,$00,$81 ;|            X      X| (12)
    .byte $00,$00,$01 ;|            X       | (13)
    .byte $00,$00,$01 ;|            X       | (14)
    .byte $00,$00,$01 ;|            X       | (15)
    .byte $00,$00,$01 ;|            X       | (16)
    .byte $00,$00,$FF ;|            XXXXXXXX| (17)
    .byte $00,$00,$00 ;|                    | (18)
    .byte $00,$00,$00 ;|                    | (19)
    .byte $00,$00,$00 ;|                    | (20)
    .byte $00,$00,$00 ;|                    | (21)
    .byte $00,$00,$00 ;|                    | (22)
    .byte $00,$00,$00 ;|                    | (23)
two:
    .byte $00,$00,$00 ;|                    | ( 0)
    .byte $00,$00,$00 ;|                    | ( 1)
    .byte $00,$00,$00 ;|                    | ( 2)
    .byte $00,$00,$00 ;|                    | ( 3)
    .byte $00,$00,$00 ;|                    | ( 4)
    .byte $00,$00,$00 ;|                    | ( 5)
    .byte $00,$00,$FF ;|            XXXXXXXX| ( 6)
    .byte $00,$00,$01 ;|            X       | ( 7)
    .byte $00,$00,$01 ;|            X       | ( 8)
    .byte $00,$00,$81 ;|            X      X| ( 9)
    .byte $00,$00,$81 ;|            X      X| (10)
    .byte $00,$00,$01 ;|            X       | (11)
    .byte $00,$00,$01 ;|            X       | (12)
    .byte $00,$00,$81 ;|            X      X| (13)
    .byte $00,$00,$81 ;|            X      X| (14)
    .byte $00,$00,$01 ;|            X       | (15)
    .byte $00,$00,$01 ;|            X       | (16)
    .byte $00,$00,$FF ;|            XXXXXXXX| (17)
    .byte $00,$00,$00 ;|                    | (18)
    .byte $00,$00,$00 ;|                    | (19)
    .byte $00,$00,$00 ;|                    | (20)
    .byte $00,$00,$00 ;|                    | (21)
    .byte $00,$00,$00 ;|                    | (22)
    .byte $00,$00,$00 ;|                    | (23)
three:
    .byte $00,$00,$00 ;|                    | ( 0)
    .byte $00,$00,$00 ;|                    | ( 1)
    .byte $00,$00,$00 ;|                    | ( 2)
    .byte $00,$00,$00 ;|                    | ( 3)
    .byte $00,$00,$00 ;|                    | ( 4)
    .byte $00,$00,$00 ;|                    | ( 5)
    .byte $00,$00,$FF ;|            XXXXXXXX| ( 6)
    .byte $00,$00,$01 ;|            X       | ( 7)
    .byte $00,$00,$81 ;|            X      X| ( 8)
    .byte $00,$00,$81 ;|            X      X| ( 9)
    .byte $00,$00,$01 ;|            X       | (10)
    .byte $00,$00,$81 ;|            X      X| (11)
    .byte $00,$00,$81 ;|            X      X| (12)
    .byte $00,$00,$01 ;|            X       | (13)
    .byte $00,$00,$81 ;|            X      X| (14)
    .byte $00,$00,$81 ;|            X      X| (15)
    .byte $00,$00,$01 ;|            X       | (16)
    .byte $00,$00,$FF ;|            XXXXXXXX| (17)
    .byte $00,$00,$00 ;|                    | (18)
    .byte $00,$00,$00 ;|                    | (19)
    .byte $00,$00,$00 ;|                    | (20)
    .byte $00,$00,$00 ;|                    | (21)
    .byte $00,$00,$00 ;|                    | (22)
    .byte $00,$00,$00 ;|                    | (23)
four:
    .byte $00,$00,$00 ;|                    | ( 0)
    .byte $00,$00,$00 ;|                    | ( 1)
    .byte $00,$00,$00 ;|                    | ( 2)
    .byte $00,$00,$00 ;|                    | ( 3)
    .byte $00,$00,$00 ;|                    | ( 4)
    .byte $00,$00,$00 ;|                    | ( 5)
    .byte $00,$00,$FF ;|            XXXXXXXX| ( 6)
    .byte $00,$00,$01 ;|            X       | ( 7)
    .byte $00,$00,$19 ;|            X  XX   | ( 8)
    .byte $00,$00,$19 ;|            X  XX   | ( 9)
    .byte $00,$00,$01 ;|            X       | (10)
    .byte $00,$00,$01 ;|            X       | (11)
    .byte $00,$00,$01 ;|            X       | (12)
    .byte $00,$00,$01 ;|            X       | (13)
    .byte $00,$00,$19 ;|            X  XX   | (14)
    .byte $00,$00,$19 ;|            X  XX   | (15)
    .byte $00,$00,$01 ;|            X       | (16)
    .byte $00,$00,$FF ;|            XXXXXXXX| (17)
    .byte $00,$00,$00 ;|                    | (18)
    .byte $00,$00,$00 ;|                    | (19)
    .byte $00,$00,$00 ;|                    | (20)
    .byte $00,$00,$00 ;|                    | (21)
    .byte $00,$00,$00 ;|                    | (22)
    .byte $00,$00,$00 ;|                    | (23)
five:
    .byte $00,$00,$00 ;|                    | ( 0)
    .byte $00,$00,$00 ;|                    | ( 1)
    .byte $00,$00,$00 ;|                    | ( 2)
    .byte $00,$00,$00 ;|                    | ( 3)
    .byte $00,$00,$00 ;|                    | ( 4)
    .byte $00,$00,$00 ;|                    | ( 5)
    .byte $00,$00,$FF ;|            XXXXXXXX| ( 6)
    .byte $00,$00,$01 ;|            X       | ( 7)
    .byte $00,$00,$19 ;|            X  XX   | ( 8)
    .byte $00,$00,$19 ;|            X  XX   | ( 9)
    .byte $00,$00,$01 ;|            X       | (10)
    .byte $00,$00,$81 ;|            X      X| (11)
    .byte $00,$00,$81 ;|            X      X| (12)
    .byte $00,$00,$01 ;|            X       | (13)
    .byte $00,$00,$19 ;|            X  XX   | (14)
    .byte $00,$00,$19 ;|            X  XX   | (15)
    .byte $00,$00,$01 ;|            X       | (16)
    .byte $00,$00,$FF ;|            XXXXXXXX| (17)
    .byte $00,$00,$00 ;|                    | (18)
    .byte $00,$00,$00 ;|                    | (19)
    .byte $00,$00,$00 ;|                    | (20)
    .byte $00,$00,$00 ;|                    | (21)
    .byte $00,$00,$00 ;|                    | (22)
    .byte $00,$00,$00 ;|                    | (23)
six:
    .byte $00,$00,$00 ;|                    | ( 0)
    .byte $00,$00,$00 ;|                    | ( 1)
    .byte $00,$00,$00 ;|                    | ( 2)
    .byte $00,$00,$00 ;|                    | ( 3)
    .byte $00,$00,$00 ;|                    | ( 4)
    .byte $00,$00,$00 ;|                    | ( 5)
    .byte $00,$00,$FF ;|            XXXXXXXX| ( 6)
    .byte $00,$00,$01 ;|            X       | ( 7)
    .byte $00,$00,$31 ;|            X   XX  | ( 8)
    .byte $00,$00,$31 ;|            X   XX  | ( 9)
    .byte $00,$00,$01 ;|            X       | (10)
    .byte $00,$00,$31 ;|            X   XX  | (11)
    .byte $00,$00,$31 ;|            X   XX  | (12)
    .byte $00,$00,$01 ;|            X       | (13)
    .byte $00,$00,$31 ;|            X   XX  | (14)
    .byte $00,$00,$31 ;|            X   XX  | (15)
    .byte $00,$00,$01 ;|            X       | (16)
    .byte $00,$00,$FF ;|            XXXXXXXX| (17)
    .byte $00,$00,$00 ;|                    | (18)
    .byte $00,$00,$00 ;|                    | (19)
    .byte $00,$00,$00 ;|                    | (20)
    .byte $00,$00,$00 ;|                    | (21)
    .byte $00,$00,$00 ;|                    | (22)
    .byte $00,$00,$00 ;|                    | (23)



    org $fffc
	.word start
    .word start
