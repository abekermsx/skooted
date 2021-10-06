

edit_hearts:
        ld a,(player_hearts)
        call get_heart_location

        ld a,e
        inc a
        jr z,edit_hearts_start

        ld (sheet_xy),de

edit_hearts_start:
        ld hl,edit_hearts_functions
        jp edit

edit_hearts_functions:
        dw edit_hearts_blink_heart
        dw edit_hearts_hide_heart
        dw edit_hearts_put_heart
        dw edit_sheet_delete_pattern


edit_hearts_put_heart:
        ld de,(sheet_xy)
        call get_pattern_at_location
        cp 5
        ret c   ; can't put heart on empty spot or blue arrows
        cp $e0
        ret z   ; can't put heart on red solid block
        and $0f
        ret nz  ; can't put heart on block placed on blue arrow

        call remove_heart_at_location

        call edit_hearts_delete_heart

        ld de,(sheet_xy)
        ld a,(player_hearts)
        call put_heart_at_location
        
        call print_pattern_xy
        ret


edit_hearts_delete_heart:
        ld a,(player_hearts)
        call get_heart_location

        ld a,d
        inc a
        ret z

        call remove_heart_at_location
        call print_pattern_xy
        ret


edit_hearts_blink_heart:
        ld a,(JIFFY)
        and 15
        cp 8
        jr c,edit_hearts_show_heart

edit_hearts_hide_heart:
        ld de,(sheet_xy)
        call print_pattern_xy
        ret

edit_hearts_show_heart:
        ld de,(sheet_xy)
        call print_heart_at_location
        ret
