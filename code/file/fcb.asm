

clear_fcb:
        ld hl,fcbdat
        ld bc,25
        xor a
        call fill_ram
        ret
        
initialize_fcb:
	ld hl,0
        ld (fcb+12),hl     ; set blocknumber to 0

        ld (fcb+33),hl     ; set random block to 0
        ld (fcb+35),hl

        ld (fcb+32),hl     ; set current record 0

        inc hl
        ld (fcb+14),hl     ; set block size to 1
        ret

fcb:    defb    0               ; drive
fname:  defb	"SKOOTER "      ; filename
fext:   defb	"ROM"           ; extension
fcbdat: defb    0,0             ; current block
        defb    0,0             ; block length
length: defb    0,0,0,0         ; file length
        defb    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0   ; other data
