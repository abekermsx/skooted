

gui_file_action:
        call jiffy_wait

        call gui_file_action_blink_action

        call get_input

        cp INPUT.UP
        jr z,gui_file_action_leave_up
        cp INPUT.RIGHT
        jr z,gui_file_action_toggle
        cp INPUT.DOWN
        jr z,gui_file_action_leave_down
        cp INPUT.LEFT
        jr z,gui_file_action_toggle

        cp INPUT.FIRE1
        jr z,gui_file_action_perform

        cp INPUT.F1
        jr z,gui_file_action_play
        cp INPUT.F2
        jr z,gui_file_action_text
        cp INPUT.F5
        jr z,gui_file_action_clear

        jr gui_file_action

gui_file_action_perform:
        ld a,(file_action)
        or a
        jp z,gui_file_select
        jp save_file

gui_file_action_text:
        ld a,GUI.TEXT
        ret

gui_file_action_clear:
        ld a,GUI.CLEAR
        ret

gui_file_action_play:
        ld a,GUI.PLAY
        ret

gui_file_action_leave_up:
        call gui_file_action_show_action
        ld a,GUI.UP
        ret

gui_file_action_toggle:
        ld hl,file_action
        ld a,(hl)
        xor 1
        ld (hl),a

        ld hl,gui_file_action_blink_action
        call wait_release
        jr gui_file_action


gui_file_action_leave_down:
        call gui_file_action_show_action
        ld a,GUI.DOWN
        ret

gui_file_action_blink_action:
        ld a,(JIFFY)
        bit 3,a
        jr z,gui_file_action_show_action

gui_file_action_hide_action:
        ld a,(file_action)
        call hide_file_action
        ret

gui_file_action_show_action:
        call initialize_gui
        ret


file_action:    db 0
