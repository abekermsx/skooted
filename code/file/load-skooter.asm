

load_skooter:
        call open_file
        ret nz

        ld a,(RAMAD1)
        ld h,$40
        call ENASLT
            
        call load_block
        
        ld hl,$8000
        ld de,$4000
        ld b,d
        ld c,e
        ldir
        
        call load_block

        call close_file

        xor a
	ret

load_block:
        ld de,$8000
        ld c,_SETDTA
        call BDOSBAS
		
        ld hl,$4000
        ld de,fcb
        ld c,_RDBLK
        call bdos_wrapper
        ret
