
edit_sheet:
        ld a,(block_y)
        cp 4
        jr c,edit_sheet_start

        ld a,(block_x)
        ld bc,SHEET.ENEMIES
        jr nz,edit_sheet_update_sheet_xy
        cpl
        and %11
        ld bc,SHEET.ITEMS
edit_sheet_update_sheet_xy:
        call calculate_object_address
        
        ld a,(hl)
        cp $ff
        jr z,edit_sheet_start

        ld e,a
        inc hl
        ld d,(hl)
        ld (sheet_xy),de

edit_sheet_start:
        ld hl,edit_sheet_functions
        jp edit

edit_sheet_functions:
        dw edit_sheet_blink_pattern
        dw edit_sheet_restore_pattern
        dw edit_sheet_put_pattern
        dw edit_sheet_delete_pattern


edit_sheet_delete_pattern:
        ld de,(sheet_x)
        call remove_heart_at_location
        call remove_enemy_at_location
        call remove_item_at_location

        call get_pattern_at_location
        ld (hl),0

edit_sheet_wait_release:
        call edit_sheet_hide_pattern

        ld hl,edit_sheet_blink_pattern
        ld b,60
        call wait_release2
        ret


edit_sheet_put_pattern:
        ld a,(block_y)
        cp 1
        jr z,edit_sheet_put_pattern_allow       ; it is allowed to have player on blue arrows, but not on other blocks

        call get_player_location

        ld hl,(sheet_xy)
        call DCOMPR
        ret z

edit_sheet_put_pattern_allow:
        ld de,(sheet_xy)
        call remove_enemy_at_location
        call remove_item_at_location

        call get_pattern_at_location
        ld b,a
        call get_selected_pattern
        cp b
        jr z,edit_sheet_delete_pattern

edit_sheet_put_pattern_not_same:
        cp $10
        jr nc,edit_sheet_select_block
        cp $0c
        jr nc,edit_sheet_put_enemy
        cp $08
        jr nc,edit_sheet_put_item

; blocks $01, $02, $03, $04 and $0e aren't allowed to have hearts behind them
edit_sheet_put_solid:
edit_sheet_put_arrow:
        scf
edit_sheet_put_block:
edit_sheet_put_block_on_arrow:
        push af
        ld de,(sheet_xy)
        call c,remove_heart_at_location
        call get_pattern_at_location
        pop af
        ld (hl),a
        jr edit_sheet_wait_release


edit_sheet_select_block:
        cp $e0  ; this pattern is not allowed to have hearts behind it and can't be put on top of blue arrow
        jr z,edit_sheet_put_solid

        ld de,(sheet_xy)
        call get_pattern_at_location

        ld b,a

        or a    ; if there's an empty block it can be updated
        jr z,edit_sheet_select_block2
        and $0f ; if it's not a block with blue arrow functionality it can be updated
        jr z,edit_sheet_select_block2

        ld a,b
        and $f0 ; if there's a block on a blue arrow then it should be converted to regular block
        jr nz,edit_sheet_select_block2

        call get_selected_pattern
        or b
        jr edit_sheet_put_block_on_arrow

edit_sheet_select_block2:
        call get_selected_pattern
        jr edit_sheet_put_block


edit_sheet_put_enemy:
        ld a,(block_x)
        ld bc,SHEET.ENEMIES
        call calculate_object_address

edit_sheet_put_enemy_or_item:        
        push hl

        ld a,(hl)
        inc a
        jr z,edit_sheet_put_enemy_or_item1

        ld e,(hl)
        ld (hl),$ff
        inc hl
        ld d,(hl)
        ld (hl),$ff

        call print_pattern_xy

edit_sheet_put_enemy_or_item1:
        ld de,(sheet_xy)
        xor a
        call set_pattern_at_location
        call remove_heart_at_location

        pop hl
        ld (hl),e
        inc hl
        ld (hl),d
        call print_pattern_xy
        ret


edit_sheet_put_item:
        ld a,(block_x)
        cpl
        and %11
        ld bc,SHEET.ITEMS
        call calculate_object_address
        jr edit_sheet_put_enemy_or_item


edit_sheet_blink_pattern:
        ld a,(JIFFY)
        and 15
        cp 8
        jr c,edit_sheet_show_pattern

edit_sheet_hide_pattern:
        ld a,(block_y)
        cp 4
        jr nc,edit_sheet_hide_pattern_item_or_enemy

        ld de,(sheet_xy)
        call get_pattern_at_location
        ld c,a
        call get_selected_pattern
        cp c
        jr nz,edit_sheet_restore_pattern

edit_sheet_hide_pattern_item_or_enemy:
        xor a
        jr edit_sheet_update_pattern

edit_sheet_show_pattern:
        call get_selected_pattern

edit_sheet_update_pattern:
        ld de,(sheet_xy)
        call fill_pattern_value
        call output_pattern
        ret

edit_sheet_restore_pattern:
        ld de,(sheet_xy)
        call print_pattern_xy
        ret

get_selected_pattern:
        ld hl,(block_xy)
        ld a,h
        add a,a
        add a,a
        add a,l
        ld l,a
        ld h,0
        ld de,pattern_list
        add hl,de
        ld a,(hl)
        ret

pattern_list:
        db $50,$60,$d0,$e0
        db $01,$02,$03,$04
        db $10,$20,$30,$40
        db $90,$a0,$b0,$c0
        db $08,$09,$0a,$0b
        db $0c,$0d,$0e,$0f
