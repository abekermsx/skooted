

gui_sheet_number:
        call jiffy_wait

        call gui_sheet_number_blink_numbers

        call get_input

        cp INPUT.UP
        jr z,gui_sheet_number_leave_up
        cp INPUT.RIGHT
        jr z,gui_sheet_number_up
        cp INPUT.DOWN
        jr z,gui_sheet_number_leave_down
        cp INPUT.LEFT
        jr z,gui_sheet_number_down

        cp INPUT.F1
        jr z,gui_sheet_number_play
        cp INPUT.FIRE1
        jr z,gui_sheet_number_play
        cp INPUT.F2
        jr z,gui_sheet_number_text
        cp INPUT.F5
        jr z,gui_sheet_number_clear

        jr gui_sheet_number

gui_sheet_number_leave_up:
        call gui_sheet_number_show_numbers
        ld a,GUI.UP
        ret

gui_sheet_number_leave_down:
        call gui_sheet_number_show_numbers
        ld a,GUI.DOWN
        ret

gui_sheet_number_text:
        ld a,GUI.TEXT
        ret

gui_sheet_number_clear:
        ld a,GUI.CLEAR
        ret

gui_sheet_number_play:
        ld a,GUI.PLAY
        ret


gui_sheet_number_blink_numbers:
        ld a,(JIFFY)
        bit 3,a
        jr z,gui_sheet_number_show_numbers

gui_sheet_number_hide_numbers:
        ld de,'  '
        call print_sheet_number
        ret

gui_sheet_number_show_numbers:
        ld hl,(gui_layout_sheet_number + 6)
        ld d,l
        ld e,h
        call print_sheet_number
        ret

gui_sheet_number_up:
        ld a,(sheet_number)
        inc a
        cp 17
        jr nz,gui_sheet_number_update
        ld a,1
gui_sheet_number_update:
        ld (sheet_number),a
        call gui_sheet_number_update_level
        jr gui_sheet_number

gui_sheet_number_down:
        ld a,(sheet_number)
        dec a
        jr nz,gui_sheet_number_update
        ld a,16
        jr gui_sheet_number_update

gui_sheet_number_update_level:
        ld a,(sheet_number)
        sub 10
        ld l,'1'
        jr nc,gui_sheet_number_update_level1
        dec l
        add a,10
gui_sheet_number_update_level1:
        add a,'0'
        ld h,a
        ld (gui_layout_sheet_number + 6),hl

        call display_screen
        ret

sheet_number:
        db 1
