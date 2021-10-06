
gui_file_select:
        call gui_file_action_show_action

        ld hl,found_files
        ld bc,SHEETS.MAXIMUM * 8
        ld a,' '
        call fill_ram

        xor a
        ld (de),a

        call search_sheets
        or a
        jp nz,gui_file_error
        
        ld a,b
        or a
        jp z,select_file_no_sheets_found

        ld (file_listing),hl
        ld (file_count),a

        xor a
        ld (file_index),a
        
        call gui_file_select_show_file_name
        
        call hide_sprite

        ld hl,wait_release_dummy
        call wait_release

gui_file_select_loop:
        call jiffy_wait

        call gui_file_select_blink_file_name

        call get_input

        cp INPUT.UP
        jr z,gui_file_select_up
        cp INPUT.DOWN
        jr z,gui_file_select_down

        cp INPUT.FIRE1
        jp z,load_file

        cp INPUT.ESC
        jr z,gui_file_select_leave
        cp INPUT.FIRE2
        jr z,gui_file_select_leave

        jr gui_file_select_loop


gui_file_select_leave:
        call initialize_gui
        jp gui_file_action


gui_file_select_up:
        ld a,(file_index)
        sub 1
        jr nc,gui_file_select_up2
        ld a,(file_count)
        dec a
gui_file_select_up2:
        ld (file_index),a

        ld hl,gui_file_select_blink_file_name
        call wait_release
        jr gui_file_select_loop


gui_file_select_down:
        ld a,(file_count)
        ld b,a
        ld a,(file_index)
        inc a
        cp b
        jr nz,gui_file_select_up2
        xor a
        jr gui_file_select_up2

gui_file_select_blink_file_name:
        ld a,(JIFFY)
        bit 3,a
        jr z,gui_file_select_show_file_name

gui_file_select_hide_file_name:
        ld a,(file_index)
        call hide_filename
        ret

gui_file_select_show_file_name:
        ld hl,file_gui
        ld de,6144 + 5 * 32 + 24
        call initialize_gui_rows

        ld hl,(file_listing)
        ld de,6144 + 6 * 32 +24
        call initialize_gui_rows
        ret


select_file_no_sheets_found:
        ld de,select_file_no_sheets_found_message
        call display_error_message
        jp gui_file_action

select_file_no_sheets_found_message:
        db 16, "No sheets found!"


file_gui:       db " -FILES-", 0

file_index:     db 0
file_count:     db 0
file_listing:   dw 0
