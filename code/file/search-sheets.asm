

; Searches for sheets (.SHT) files on disk
; Out: A: 255 = disk error
;      B: number of sheets found
;      HL: address of list with files found (if sheets found)
search_sheets:
        call clear_fcb

        ld hl,search_filename
        ld de,fname
        ld bc,11
        ldir
        
        ld de,found_file_fcb
        ld c,_SETDTA
        call BDOSBAS

        ld de,fcb
        ld c,_SFIRST
        call bdos_wrapper
        or a
        jr nz,search_sheets_not_found   ; not found, or disk error

        ld hl,found_file_fcb + 1
        ld de,found_files
        ld bc,8
        ldir

        ld b,SHEETS.MAXIMUM - 1
search_sheets_loop:
        push bc
        push de
        ld c,_SNEXT
        call bdos_wrapper
        pop de
        pop bc
        or a
        jr nz,search_sheets_end

        ld hl,found_file_fcb + 1
        push bc
        ld bc,8
        ldir
        pop bc

        djnz search_sheets_loop

search_sheets_end:
        ld a,SHEETS.MAXIMUM
        sub b
        ld b,a
        ld hl,found_files
        ld a,(bdos_error)
        ret


search_sheets_not_found:
        ld b,0
        ld a,(bdos_error)
        ret

search_filename:
        db "????????SHT"


found_file_fcb: equ $c000
found_files:    equ $c100
