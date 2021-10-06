
gui_player_hearts:
        call jiffy_wait

        call gui_player_hearts_blink

        call get_input

        cp INPUT.UP
        jr z,gui_player_hearts_leave_up
        cp INPUT.RIGHT
        jr z,gui_player_hearts_right
        cp INPUT.DOWN
        jr z,gui_player_hearts_leave_down
        cp INPUT.LEFT
        jr z,gui_player_hearts_left

        cp INPUT.FIRE1
        jr z,gui_player_hearts_action

        cp INPUT.DEL
        jr z,gui_player_hearts_delete
        cp INPUT.FIRE2
        jr z,gui_player_hearts_delete

        cp INPUT.F1
        jr z,gui_player_hearts_play
        cp INPUT.F2
        jr z,gui_player_hearts_text
        cp INPUT.F5
        jr z,gui_player_hears_clear

        jr gui_player_hearts

gui_player_hearts_action:
        call gui_player_hearts_show

        ld a,(player_hearts)
        cp 4
        ld a,GUI.PLAYER
        ret z
        ld a,GUI.HEARTS
        ret

gui_player_hearts_text:
        ld a,GUI.TEXT
        ret

gui_player_hears_clear:
        ld a,GUI.CLEAR
        ret

gui_player_hearts_play:
        ld a,GUI.PLAY
        ret

gui_player_hearts_delete:
        ld a,(player_hearts)
        cp 4
        jr z,gui_player_hearts

        call edit_hearts_delete_heart
        
        jr gui_player_hearts

gui_player_hearts_leave_up:
        call gui_player_hearts_show
        ld a,GUI.UP
        ret

gui_player_hearts_right:
        ld a,(player_hearts)
        inc a
        cp 5
        jr nz,gui_player_hearts_update_position
        xor a
gui_player_hearts_update_position:
        ld (player_hearts),a

gui_player_hearts_wait_release:
        ld hl,gui_player_hearts_blink
        call wait_release
        jr gui_player_hearts


gui_player_hearts_leave_down:
        call gui_player_hearts_show
        ld a,GUI.DOWN
        ret


gui_player_hearts_left:
        ld a,(player_hearts)
        sub 1
        jr nc,gui_player_hearts_update_position
        ld a,4
        jr gui_player_hearts_update_position


gui_player_hearts_blink:
        ld a,(JIFFY)
        bit 3,a
        jr z,gui_player_hearts_show

gui_player_hearts_hide:
        ld a,(player_hearts)
        cp 4
        jr z,gui_player_hearts_hide_player

        call hide_heart
        ret

gui_player_hearts_hide_player:
        ld a,SPRITE.GUI
        ld hl,240 * 256 + 220
        call update_sprite_attributes
        ret

gui_player_hearts_show:
        call initialize_gui
        ret

player_hearts:  db 0
