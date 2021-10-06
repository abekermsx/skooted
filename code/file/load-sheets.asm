
; TODO: simplify by loading the whole file at once
; TODO: add support for loading texts

load_sheets:
        call open_file
        ret nz

        ld de,SKOOTER.SHEETS
        ld b,3
load_sheets_loop:
        push bc
        push de        
        
        ld de,load_buffer
        ld c,_SETDTA
        call BDOSBAS
        
        ld de,fcb
        ld hl,2048
        ld c,_RDBLK
        call bdos_wrapper
        pop de
        pop bc
        or a
        ret nz

        push bc
        
        ld hl,load_buffer
        ld bc,2048
        ldir

        pop bc

        djnz load_sheets_loop

        call close_file
        ret

load_buffer: equ $c000
