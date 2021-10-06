
edit:
        ld e,(hl)
        inc hl
        ld d,(hl)
        ld (edit_blink + 1),de
        ld (edit_wait_release + 1),de
        
        inc hl
        ld e,(hl)
        inc hl
        ld d,(hl)
        ld (edit_restore_position + 1),de
        
        inc hl
        ld e,(hl)
        inc hl
        ld d,(hl)
        ld (edit_put + 1),de
        
        inc hl
        ld e,(hl)
        inc hl
        ld d,(hl)
        ld (edit_delete + 1),de
        
        ld hl,wait_release_dummy
        call wait_release

edit_loop:
        call jiffy_wait

edit_blink:
        call $ffff

        call get_input

        cp INPUT.UP
        jr z,edit_up
        cp INPUT.RIGHT
        jr z,edit_right
        cp INPUT.DOWN
        jr z,edit_down
        cp INPUT.LEFT
        jr z,edit_left

        cp INPUT.FIRE1
        jr z,edit_put

        cp INPUT.F1
        jr z,edit_play

        cp INPUT.F2
        jr z,edit_text

        cp INPUT.F5
        jr z,edit_clear

        cp INPUT.DEL
        jr z,edit_delete

        cp INPUT.FIRE2
        jr z,edit_leave
        cp INPUT.ESC
        jr z,edit_leave

        jr edit_loop

edit_text:
        ld a,GUI.TEXT
        ret

edit_clear:
        ld a,GUI.CLEAR
        ret

edit_play:
        ld a,GUI.PLAY
        ret

edit_leave:
        call edit_restore_position
        xor a
        ret

edit_put:
        call $ffff
        jr edit_loop

edit_delete:
        call $ffff
        jr edit_loop


edit_wait_release:
        ld hl,$ffff
        call wait_release
        jr edit_loop

edit_restore_position:
        call $ffff
        ret
        

edit_up:
        call edit_restore_position

        ld a,(sheet_y)
        sub 1
        jr nc,edit_update_y
        ld a,10
edit_update_y:
        ld (sheet_y),a
        jr edit_wait_release

edit_down:
        call edit_restore_position
        
        ld a,(sheet_y)
        inc a
        cp 11
        jr nz,edit_update_y
        xor a
        jr edit_update_y

edit_left:
        call edit_restore_position
        
        ld a,(sheet_x)
        sub 1
        jr nc,edit_update_x
        ld a,10
        jr edit_update_x

edit_right:
        call edit_restore_position
        
        ld a,(sheet_x)
        inc a
        cp 11
        jr nz,edit_update_x
        xor a
edit_update_x:
        ld (sheet_x),a
        jr edit_wait_release
        
sheet_xy:
sheet_x:    db 0
sheet_y:    db 0
