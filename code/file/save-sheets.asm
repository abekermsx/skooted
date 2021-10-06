
; TODO: simplify by saving the whole file at once
; TODO: add support for saving texts

save_sheets:
        call clear_fcb

        ld de,fcb
        ld c,_FMAKE
        call bdos_wrapper
        or a
        ret nz

        call initialize_fcb

        ld hl,SKOOTER.SHEETS
        ld b,3
save_sheets_loop:
        push bc
        
        ld de,save_buffer
        ld bc,2048
        ldir
        
        push hl

        ld de,save_buffer
        ld c,_SETDTA
        call BDOSBAS

        ld de,fcb
        ld hl,2048
        ld c,_WRBLK
        call bdos_wrapper
        
        pop hl
        pop bc

        or a
        ret nz

        djnz save_sheets_loop

        call close_file
        ret

save_buffer: equ $c000
