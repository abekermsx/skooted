
; Get the player location
; Out: D = Y, E = X
get_player_location:
        ld hl,(sheet_pointer)
        ld de,SHEET.PLAYER
        add hl,de
        ld e,(hl)
        inc hl
        ld d,(hl)
        ret


; Set the player location
; In: D = Y, E = X
set_player_location:
        ld hl,(sheet_pointer)
        ld bc,SHEET.PLAYER
        add hl,bc
        
        ld (hl),e
        inc hl
        ld (hl),d
        ret
