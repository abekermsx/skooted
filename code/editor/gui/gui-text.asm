
gui_text:
        ld hl,(sheet_pointer)
        ld bc,SHEET.TEXT
        add hl,bc

        ld e,(hl)
        inc hl
        ld d,(hl)
        inc hl
        ld a,(hl)
        ld (gui_text_xy),de
        ld (gui_text_character),a

        ld a,17
        call get_sheet_address
        ld de,SKOOTER.SHEETS
        or a
        sbc hl,de
        ex de,hl
        ld hl,6144
        sbc hl,de
        ld (gui_text_free_space_old),hl

        call initialize_text_gui
        
        call KILBUF

gui_text_loop:
        call jiffy_wait

        call gui_text_blink_character

        call get_input
        cp INPUT.ESC
        jr z,gui_text_leave
        cp INPUT.FIRE2
        jr z,gui_text_leave
        
        ld de,(gui_text_xy)

        cp INPUT.UP
        jr z,gui_text_up
        cp INPUT.RIGHT
        jr z,gui_text_right
        cp INPUT.DOWN
        jr z,gui_text_down
        cp INPUT.LEFT
        jr z,gui_text_left

        cp INPUT.F1
        jr z,gui_text_play
        cp INPUT.F5
        jr z,gui_text_clear

        ld e,$ff
        ld c,_DIRIO
        call BDOSBAS
        or a
        jp nz,gui_text_input_character

        jr gui_text_loop


gui_text_up:
        ld a,d
        dec a
        cp 1
        jr nz,gui_text_update_y
        ld a,23
gui_text_update_y:
        ld (gui_text_y),a

gui_text_wait_release:
        ld a,(gui_text_character)
        call set_text_character

        ld de,(gui_text_x)
        call get_text_character
        ld (gui_text_character),a

gui_text_wait_release2:
        call gui_text_update_info

        ld hl,gui_text_blink_character
        call wait_release
        jr gui_text_loop


gui_text_down:
        ld a,d
        inc a
        cp 24
        jr c,gui_text_update_y
        ld a,2
        jr gui_text_update_y


gui_text_right:
        ld a,e
        inc a
gui_text_update_x:
        and 31
        ld (gui_text_x),a
        jr gui_text_wait_release

gui_text_left:
        ld a,e
        dec a
        jr gui_text_update_x


gui_text_leave:
        call gui_text_has_free_space
        jp nz,gui_text_loop

        call gui_text_update_sheet

        call display_screen
        xor a
        ret

gui_text_play:
        call gui_text_has_free_space
        jp nz,gui_text_loop

        call gui_text_update_sheet

        ld a,GUI.PLAY
        ret

gui_text_has_free_space:
        ld a,(gui_text_free_space_new + 1)
        and 128
        ret

gui_text_update_sheet:
        ld de,(gui_text_xy)
        call gui_text_show_character

        call update_sheet_text
        ret

gui_text_clear:
        call clear_text_area

        ld a,' '
        ld (gui_text_character),a
        
        ld hl,2 * 256 + 0
        ld (gui_text_xy),hl
        jr gui_text_wait_release2


gui_text_input_character:
        cp 8
        jr z,gui_text_input_character_backspace
        cp 13
        jr z,gui_text_input_character_enter
        cp 32
        jp c,gui_text_loop
        cp 127
        jr z,gui_text_input_character_delete
        jp nc,gui_text_loop

        call gui_text_update_character
        
        ld hl,(gui_text_xy)
        inc l
        ld a,l
        cp 32
        jr c,gui_text_input_character2
        ld l,0
        inc h
        ld a,h
        cp 24
        jr c,gui_text_input_character2
        ld h,2
gui_text_input_character2:
        ld (gui_text_xy),hl
        jp gui_text_wait_release


gui_text_input_character_backspace:
        ld de,(gui_text_xy)
        ld a,(gui_text_character)
        call gui_text_display_character
        dec e
        jp m,gui_text_input_character_backspace_previous_line
        ld (gui_text_xy),de
        jr gui_text_input_character_delete2

gui_text_input_character_backspace_previous_line:
        ld e,31
        dec d
        ld a,d
        cp 2
        jr nc,gui_text_input_character_backspace_previous_line1
        ld d,23
gui_text_input_character_backspace_previous_line1:
        ld (gui_text_xy),de
        jr gui_text_input_character_delete2


gui_text_input_character_space:
        ld a,' '
        call gui_text_update_character
        jp gui_text_wait_release


gui_text_input_character_delete:
        ld de,(gui_text_x)
gui_text_input_character_delete2:        
        ld a,e
        sub 31
        jr z,gui_text_input_character_space
        neg

        call shift_text

        ld de,(gui_text_xy)
        jp gui_text_wait_release


gui_text_input_character_enter:
        ld a,(gui_text_character)
        call gui_text_display_character

        ld a,(gui_text_y)
        inc a
        cp 24
        jr c,gui_text_input_character_enter1
        ld a,2
gui_text_input_character_enter1:
        ld h,a
        ld l,0
        ld (gui_text_xy),hl
        jp gui_text_wait_release


; Update a character at the current location
; In: A: new character
gui_text_update_character:
        ld (gui_text_character),a
gui_text_display_character:
        ld de,(gui_text_xy)
        call set_text_character
        ret


gui_text_update_info:
        call text_to_messages
        call calculate_message_size_change

        ld hl,(gui_text_free_space_old)
        or a
        sbc hl,bc
        ld (gui_text_free_space_new),hl
        call text_update_info
        ret


gui_text_blink_character:
        ld de,(gui_text_xy)

        ld a,(JIFFY)
        bit 3,a
        ld a,255
        jr nz,gui_text_display_character

gui_text_show_character:
        ld a,(gui_text_character)
        jr gui_text_display_character


gui_text_free_space_old: dw 0
gui_text_free_space_new: dw 0

gui_text_xy:
gui_text_x: db 0
gui_text_y: db 0

gui_text_character: db 0
