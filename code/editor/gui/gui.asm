
gui:
        ld hl,wait_release_dummy
        call wait_release

        ld a,(current_gui)
        ld hl,gui_parts
        call jump_to_function

gui_events:
        cp GUI.CLEAR
        jr z,gui_event_clear

        cp GUI.PLAY
        jr z,gui_event_play

        cp GUI.TEXT
        jp z,gui_event_text

        cp GUI.SHEET
        jr z,gui_event_edit_sheet

        cp GUI.PLAYER
        jr z,gui_event_edit_player

        cp GUI.HEARTS
        jr z,gui_event_edit_hearts

        cp GUI.UP
        jr z,gui_event_up

        cp GUI.DOWN
        jr z,gui_event_down

        jr gui


gui_event_down:
        xor a
        ld (block_y),a
        
        ld a,(current_gui)
        inc a
        cp gui_count
        jr nz,gui_update_current_gui
        xor a
gui_update_current_gui:
        ld (current_gui),a      
        jr gui

gui_event_up:
        ld a,5
        ld (block_y),a

        ld a,(current_gui)
        sub 1
        jr nc,gui_update_current_gui
        ld a,gui_count - 1
        jr gui_update_current_gui

gui_event_edit_sheet:
        call edit_sheet
        jr gui_events

gui_event_edit_player:
        call edit_player
        jr gui_events

gui_event_edit_hearts:
        call edit_hearts
        jr gui_events

gui_event_clear:
        call clear_sheet
        call display_screen
        jr gui

gui_event_text:
        call gui_text
        jr gui_events

gui_event_play:
        call validate_sheets
        or a
        ret z

        call gui_sheet_error
        jr gui


current_gui: db 0

gui_parts:
        dw gui_file_name
        dw gui_file_action
        dw gui_sheet_number
        dw gui_blocks
        dw gui_player_hearts
gui_parts_end:

gui_count:   equ (gui_parts_end - gui_parts) / 2
