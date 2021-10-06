

save_file:
        ld hl,gui_layout + 8
        ld a,(hl)
        cp '.'
        jr z,save_file_error_missing_filename

        ld de,fname
        ld b,8
copy_filename_loop:
        ld a,(hl)
        cp '.'
        jr nz,copy_filename_loop2
        ld a,' '
copy_filename_loop2:
        ld (de),a
        inc hl
        inc de
        djnz copy_filename_loop

        ex de,hl
        ld (hl),'S'
        inc hl
        ld (hl),'H'
        inc hl
        ld (hl),'T'

        call save_sheets
        or a
        jr nz,save_file_error_disk_error

        jp gui_file_action
        
save_file_error_missing_filename:
        ld de,save_file_error_missing_filename_message
        call display_error_message
        jp gui_file_action
        
save_file_error_missing_filename_message:
        db 24, "Please enter a filename!"

save_file_error_disk_error:
        ld a,(bdos_error)
        or a
        jp nz,gui_file_error

        ld de,save_file_error_disk_error_message
        call display_error_message
        jp gui

save_file_error_disk_error_message:
        db 18, "Error saving file!"
