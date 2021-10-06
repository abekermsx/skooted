
initialize_vdp:
    	ld a,2
        call CHGMOD

        ld a,(RG1SAV)
        or 2
        ld b,a
        ld c,1
        call WRTVDP

        ld bc,7
        call WRTVDP
        ret
