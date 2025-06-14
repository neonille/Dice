; vcs.h
; version 1.06, 06/sep/2020

version_vcs         = 106

; this is *the* "standard" vcs.h
; this file is explicitly supported as a dasm-preferred companion file
; the latest version can be found at https://dasm-assembler.github.io/
;
; this file defines hardware registers and memory mapping for the
; atari 2600. it is distributed as a companion machine-specific support package
; for the dasm compiler. updates to this file, dasm, and associated tools are
; available at at https://dasm-assembler.github.io/
;
; many thanks to the people who have contributed. if you find an issue with the
; contents, or would like ot add something, please report as an issue at...
; https://github.com/dasm-assembler/dasm/issues

;
; latest revisions...
; 1.06  05/sep/2020     modified header/license and links to new versions
; 1.05  13/nov/2003      - correction to 1.04 - now functions as requested by mr.
;                        - added version_vcs equate (which will reflect 100x version #)
;                          this will allow conditional code to verify vcs.h being
;                          used for code assembly.
; 1.04  12/nov/2003     added tia_base_write_address and tia_base_read_address for
;                       convenient disassembly/reassembly compatibility for hardware
;                       mirrored reading/writing differences.  this is more a 
;                       readability issue, and binary compatibility with disassembled
;                       and reassembled sources.  per manuel rotschkar's suggestion.
; 1.03  12/may/2003     added seg segment at end of file to fix old-code compatibility
;                       which was broken by the use of segments in this file, as
;                       reported by manuel polik on [stella] 11/may/2003
; 1.02  22/mar/2003     added timint($285)
; 1.01	        		constant offset added to allow use for 3f-style bankswitching
;						 - define tia_base_address as $40 for tigervision carts, otherwise
;						   it is safe to leave it undefined, and the base address will
;						   be set to 0.  thanks to eckhard stolberg for the suggestion.
;                          note, may use -dlabel=expression to define tia_base_address
;                        - register definitions are now generated through assignment
;                          in uninitialised segments.  this allows a changeable base
;                          address architecture.
; 1.0	22/mar/2003		initial release


;-------------------------------------------------------------------------------

; tia_base_address
; the tia_base_address defines the base address of access to tia registers.
; normally 0, the base address should (externally, before including this file)
; be set to $40 when creating 3f-bankswitched (and other?) cartridges.
; the reason is that this bankswitching scheme treats any access to locations
; < $40 as a bankswitch.

			ifnconst tia_base_address
tia_base_address	= 0
			endif

; note: the address may be defined on the command-line using the -d switch, eg:
; dasm.exe code.asm -dtia_base_address=$40 -f3 -v5 -ocode.bin
; *or* by declaring the label before including this file, eg:
; tia_base_address = $40
;   include "vcs.h"

; alternate read/write address capability - allows for some disassembly compatibility
; usage ; to allow reassembly to binary perfect copies).  this is essentially catering
; for the mirrored rom hardware registers.

; usage: as per above, define the tia_base_read_address and/or tia_base_write_address
; using the -d command-line switch, as required.  if the addresses are not defined, 
; they defaut to the tia_base_address.

     ifnconst tia_base_read_address
tia_base_read_address = tia_base_address
     endif

     ifnconst tia_base_write_address
tia_base_write_address = tia_base_address
     endif

;-------------------------------------------------------------------------------

			seg.u tia_registers_write
			org tia_base_write_address

	; do not change the relative ordering of registers!
    
vsync       ds 1    ; $00   0000 00x0   vertical sync set-clear
vblank		ds 1	; $01   xx00 00x0   vertical blank set-clear
wsync 		ds 1	; wsync    ---- ----   wait for horizontal blank
rsync		ds 1	; $03   ---- ----   reset horizontal sync counter
nusiz0		ds 1	; $04   00xx 0xxx   number-size player/missle 0
nusiz1		ds 1	; $05   00xx 0xxx   number-size player/missle 1
colup0		ds 1	; $06   xxxx xxx0   color-luminance player 0
colup1      ds 1    ; $07   xxxx xxx0   color-luminance player 1
colupf      ds 1    ; $08   xxxx xxx0   color-luminance playfield
colubk      ds 1    ; $09   xxxx xxx0   color-luminance background
ctrlpf      ds 1    ; $0a   00xx 0xxx   control playfield, ball, collisions
refp0       ds 1    ; $0b   0000 x000   reflection player 0
refp1       ds 1    ; $0c   0000 x000   reflection player 1
pf0         ds 1    ; $0d   xxxx 0000   playfield register byte 0
pf1         ds 1    ; $0e   xxxx xxxx   playfield register byte 1
pf2         ds 1    ; $0f   xxxx xxxx   playfield register byte 2
resp0       ds 1    ; $10   ---- ----   reset player 0
resp1       ds 1    ; $11   ---- ----   reset player 1
resm0       ds 1    ; $12   ---- ----   reset missle 0
resm1       ds 1    ; $13   ---- ----   reset missle 1
resbl       ds 1    ; $14   ---- ----   reset ball
audc0       ds 1    ; $15   0000 xxxx   audio control 0
audc1       ds 1    ; $16   0000 xxxx   audio control 1
audf0       ds 1    ; $17   000x xxxx   audio frequency 0
audf1       ds 1    ; $18   000x xxxx   audio frequency 1
audv0       ds 1    ; $19   0000 xxxx   audio volume 0
audv1       ds 1    ; $1a   0000 xxxx   audio volume 1
grp0        ds 1    ; $1b   xxxx xxxx   graphics register player 0
grp1        ds 1    ; $1c   xxxx xxxx   graphics register player 1
enam0       ds 1    ; $1d   0000 00x0   graphics enable missle 0
enam1       ds 1    ; $1e   0000 00x0   graphics enable missle 1
enabl       ds 1    ; $1f   0000 00x0   graphics enable ball
hmp0        ds 1    ; $20   xxxx 0000   horizontal motion player 0
hmp1        ds 1    ; $21   xxxx 0000   horizontal motion player 1
hmm0        ds 1    ; $22   xxxx 0000   horizontal motion missle 0
hmm1        ds 1    ; $23   xxxx 0000   horizontal motion missle 1
hmbl        ds 1    ; $24   xxxx 0000   horizontal motion ball
vdelp0      ds 1    ; $25   0000 000x   vertical delay player 0
vdelp1      ds 1    ; $26   0000 000x   vertical delay player 1
vdelbl      ds 1    ; $27   0000 000x   vertical delay ball
resmp0      ds 1    ; $28   0000 00x0   reset missle 0 to player 0
resmp1      ds 1    ; $29   0000 00x0   reset missle 1 to player 1
hmove       ds 1    ; $2a   ---- ----   apply horizontal motion
hmclr       ds 1    ; $2b   ---- ----   clear horizontal move registers
cxclr       ds 1    ; $2c   ---- ----   clear collision latches
 
;-------------------------------------------------------------------------------

			seg.u tia_registers_read
			org tia_base_read_address

                    ;											bit 7   bit 6
cxm0p       ds 1    ; $00       xx00 0000       read collision  m0-p1   m0-p0
cxm1p       ds 1    ; $01       xx00 0000                       m1-p0   m1-p1
cxp0fb      ds 1    ; wsync        xx00 0000                       p0-pf   p0-bl
cxp1fb      ds 1    ; $03       xx00 0000                       p1-pf   p1-bl
cxm0fb      ds 1    ; $04       xx00 0000                       m0-pf   m0-bl
cxm1fb      ds 1    ; $05       xx00 0000                       m1-pf   m1-bl
cxblpf      ds 1    ; $06       x000 0000                       bl-pf   -----
cxppmm      ds 1    ; $07       xx00 0000                       p0-p1   m0-m1
inpt0       ds 1    ; $08       x000 0000       read pot port 0
inpt1       ds 1    ; $09       x000 0000       read pot port 1
inpt2       ds 1    ; $0a       x000 0000       read pot port 2
inpt3       ds 1    ; $0b       x000 0000       read pot port 3
inpt4       ds 1    ; $0c		x000 0000       read input (trigger) 0
inpt5       ds 1	; $0d		x000 0000       read input (trigger) 1

;-------------------------------------------------------------------------------

			seg.u riot
			org $280
 
	; riot memory map

swcha       ds 1    ; $280      port a data register for joysticks:
					;			bits 4-7 for player 1.  bits 0-3 for player 2.

swacnt      ds 1    ; $281      port a data direction register (ddr)
swchb       ds 1    ; $282		port b data (console switches)
swbcnt      ds 1    ; $283      port b ddr
intim       ds 1    ; $284		timer output

timint  	ds 1	; $285

		; unused/undefined registers ($285-$294)

			ds 1	; $286
			ds 1	; $287
			ds 1	; $288
			ds 1	; $289
			ds 1	; $28a
			ds 1	; $28b
			ds 1	; $28c
			ds 1	; $28d
			ds 1	; $28e
			ds 1	; $28f
			ds 1	; $290
			ds 1	; $291
			ds 1	; $292
			ds 1	; $293

tim1t       ds 1    ; $294		set 1 clock interval
tim8t       ds 1    ; $295      set 8 clock interval
tim64t      ds 1    ; $296      set 64 clock interval
t1024t      ds 1    ; $297      set 1024 clock interval

;-------------------------------------------------------------------------------
; the following required for back-compatibility with code which does not use
; segments.

            seg

; eof
