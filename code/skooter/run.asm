
run_skooter:
        ; set the number of lives to 42
        ld a,42
        ld (SKOOTER.LIVES),a

        ; reset RAM to prevent sprites to be displayed on
        ld hl,SKOOTER.RAM_VARIABLES
        ld bc,$c00
        xor a
        call fill_ram
        
        ld hl,HKEYI
        ld de,HKEYI_backup
        ld bc,5
        ldir

        ld (SP_backup),sp

        ld hl,($4002)
		jp (hl)

end_skooter:
        di
        ld sp,(SP_backup)

        ld hl,HKEYI_backup
        ld de,HKEYI
        ld bc,5
        ldir

        call GICINI
        ret

SP_backup:
        dw 0

HKEYI_backup:
        ds 5
