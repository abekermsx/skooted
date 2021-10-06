
gui_blocks:
        call jiffy_wait

        call gui_blocks_blink_pattern

        call get_input
        
        cp INPUT.UP
        jr z,gui_blocks_up
        cp INPUT.RIGHT
        jr z,gui_blocks_right
        cp INPUT.DOWN
        jr z,gui_blocks_down
        cp INPUT.LEFT
        jr z,gui_blocks_left
        
        cp INPUT.F1
        jr z,gui_blocks_play
        cp INPUT.F2
        jr z,gui_blocks_text
        cp INPUT.F5
        jr z,gui_blocks_clear

        cp INPUT.FIRE1
        jr z,gui_blocks_sheet

        jr gui_blocks

gui_blocks_text:
        ld a,GUI.TEXT
        ret

gui_blocks_clear:
        ld a,GUI.CLEAR
        ret

gui_blocks_play:
        ld a,GUI.PLAY
        ret

gui_blocks_sheet:
        call gui_blocks_show_pattern
        ld a,GUI.SHEET
        ret


gui_blocks_up:
        ld a,(block_y)
        sub 1
        jr c,gui_blocks_leave_up
gui_blocks_update_move_y:
        ld (block_y),a
        jr gui_blocks_wait_release

gui_blocks_down:
        ld a,(block_y)
        cp 5
        jr z,gui_blocks_leave_down
        inc a
        jr gui_blocks_update_move_y


gui_blocks_right:
        ld a,(block_x)
        inc a
gui_blocks_update_move_x:
        and 3
        ld (block_x),a
        jr gui_blocks_wait_release

gui_blocks_left:
        ld a,(block_x)
        dec a
        jr gui_blocks_update_move_x


gui_blocks_leave_up:
        call gui_blocks_show_pattern
        ld a,GUI.UP
        ret

gui_blocks_leave_down:
        call gui_blocks_show_pattern
        ld a,GUI.DOWN
        ret

gui_blocks_wait_release:
        ld hl,gui_blocks_blink_pattern
        call wait_release
        jr gui_blocks

gui_blocks_blink_pattern:
        ld a,(JIFFY)
        bit 3,a
        jr z,gui_blocks_show_pattern

gui_blocks_hide_pattern:
        ld hl,0
        ld (pattern_buffer),hl
        ld (pattern_buffer + 2),hl
        
        ld hl,4 * 256 + 12
        ld de,(block_x)
        add hl,de
        ex de,hl
        call calculate_tile_vram_address
        dec hl
        call output_pattern_buffer
        ret


gui_blocks_show_pattern:
        call initialize_gui
        ret

block_xy:
block_x:    db 0
block_y:    db 0
