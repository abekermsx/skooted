
gui_file_name:
        ld hl,gui_layout + 8 - 1
        ld b,255
gui_file_name_init:
        inc b
        inc hl
        ld a,(hl)
        cp '.'
        jr z,gui_file_name_init_end
        dec a
        jr nz,gui_file_name_init
        dec b
gui_file_name_init_end:
        ld a,b
        ld (file_name_position),a
        
        call KILBUF

gui_file_name_loop:
        call jiffy_wait

        call gui_file_name_blink_character

        call get_input

        cp INPUT.UP
        jr z,gui_file_name_leave_up
        cp INPUT.DOWN
        jr z,gui_file_name_leave_down
        
        cp INPUT.F1
        jr z,gui_file_name_play
        cp INPUT.F2
        jr z,gui_file_name_text
        cp INPUT.F5
        jr z,gui_file_name_clear
        
        ld e,$ff
        ld c,_DIRIO
        call BDOSBAS
        or a
        jr nz,gui_file_name_input_character

        jr gui_file_name_loop

gui_file_name_text:
        ld a,GUI.TEXT
        ret

gui_file_name_clear:
        ld a,GUI.CLEAR
        ret

gui_file_name_play:
        ld a,GUI.PLAY
        ret

gui_file_name_leave_up:
        call gui_file_name_show_character
        ld a,GUI.UP
        ret

gui_file_name_leave_down:
        call gui_file_name_show_character
        ld a,GUI.DOWN
        ret


gui_file_name_blink_character:
        ld a,(JIFFY)
        bit 3,a
        jr z,gui_file_name_show_character

gui_file_name_hide_character:
        ld a,(file_name_position)
        call hide_filename_character
        ret

gui_file_name_show_character:
        call initialize_gui
        ret

gui_file_name_input_character:
        cp 8
        jr z,gui_file_name_input_character_backspace
        cp '-'
        jr z,gui_file_name_input_character_allowed
        cp '0'
        jr c,gui_file_name_loop
        cp '9'+1
        jr c,gui_file_name_input_character_allowed
        cp 'A'
        jr c,gui_file_name_loop
        cp 'Z'+1
        jr c,gui_file_name_input_character_allowed
        cp 'a'
        jr c,gui_file_name_loop
        cp 'z'+1
        jr nc,gui_file_name_loop
        sub 32

gui_file_name_input_character_allowed:
        push af
        call initialize_gui
        
        ld hl,gui_layout + 8
        ld a,(file_name_position)
        ld e,a
        ld d,0
        add hl,de

        pop af
        ld (hl),a

        ld a,(file_name_position)
        cp 7
        jr z,gui_file_name_input_character_wait_release
        inc a
        ld (file_name_position),a

gui_file_name_input_character_wait_release:
        call gui_file_name_show_character

gui_file_name_input_character_wait_release_loop:        
        call jiffy_wait
        call gui_file_name_blink_character
        
        ld e,$ff
        ld c,_DIRIO
        call BDOSBAS
        or a
        jr nz,gui_file_name_input_character_wait_release_loop
        jp gui_file_name_loop

gui_file_name_input_character_backspace:
        ld a,(file_name_position)
        or a
        jp z,gui_file_name_loop
        
        ld hl,gui_layout + 8
        ld e,a
        ld d,0
        add hl,de

        cp 7
        jr nz,gui_file_name_input_character_backspace_update_position

        ld a,(hl)
        cp '.'
        jr z,gui_file_name_input_character_backspace_update_position

        ld (hl),'.'
        jr gui_file_name_input_character_wait_release

gui_file_name_input_character_backspace_update_position:
        ld a,(file_name_position)
        dec a
        ld (file_name_position),a
        dec hl
        ld (hl),'.'
        jr gui_file_name_input_character_wait_release

file_name_position: db 0
