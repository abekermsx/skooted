
load_file:
        ld a,(file_index)
        add a,a
        add a,a
        add a,a
        ld e,a
        ld d,0
        ld hl,found_files
        add hl,de

        push hl
        
        ld de,gui_layout + 8
        ld b,8
update_gui_filename_loop:
        ld a,(hl)
        cp ' '
        jr nz,update_gui_filename_loop2
        ld a,'.'
update_gui_filename_loop2:
        ld (de),a
        inc de
        inc hl
        djnz update_gui_filename_loop     

        pop hl

        ld de,fname
        ld bc,8
        ldir

        ex de,hl
        ld (hl),'S'
        inc hl
        ld (hl),'H'
        inc hl
        ld (hl),'T'

        call load_sheets
        or a
        jr nz,load_file_error_disk_error

        ld a,1
        ld (sheet_number),a

        call gui_sheet_number_update_level

        jp gui_file_action

        
load_file_error_disk_error:
        ld a,(bdos_error)
        or a
        jp nz,gui_file_error

        ld de,load_file_error_disk_error_message
        call display_error_message
        jp gui_file_action

load_file_error_disk_error_message:
        db 19, "Error loading file!"
