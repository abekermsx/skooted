
edit_player:
        call get_player_location
        ld (sheet_xy),de

        ld hl,edit_player_functions
        jp edit

edit_player_functions:
        dw edit_player_blink_sprite
        dw edit_player_restore_sprite
        dw edit_player_put_player
        dw edit_sheet_delete_pattern


edit_player_put_player:
        ld de,(sheet_xy)
        call set_player_location
        
        call remove_enemy_at_location
        call remove_item_at_location
        call remove_heart_at_location

        call get_pattern_at_location
        cp 5
        jr c,edit_player_put_player1
        xor a
        call set_pattern_at_location

edit_player_put_player1:
        ld de,(sheet_xy)
        call print_pattern_xy

        call print_player_sprite
        ret
        

edit_player_blink_sprite:
        call get_player_location
       
        ld hl,(sheet_xy)
        call DCOMPR
        jr nz,edit_player_blink_sprite2
        ld de,14 * 256
edit_player_blink_sprite2:
        ld a,SPRITE.PLAYER
        call print_sprite_at_location

        ld a,(JIFFY)
        and 15
        cp 8
        ld de,(sheet_xy)
        jr c,edit_player_show_cursor_sprite2

edit_player_hide_cursor_sprite:
        ld de,14 * 256
edit_player_show_cursor_sprite2:
        ld a,SPRITE.CURSOR
        call print_sprite_at_location
        ret

edit_player_restore_sprite:
        call get_player_location

        ld a,SPRITE.PLAYER
        call print_sprite_at_location
        jr edit_player_hide_cursor_sprite

