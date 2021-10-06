

; Print a player sprite in the sheet
print_player_sprite:
        ld hl,(sheet_pointer)
        ld de,SHEET.PLAYER
        add hl,de
        ld e,(hl)
        inc hl
        ld d,(hl)
        ld a,SPRITE.PLAYER
        call print_sprite_at_location
        ret


; Display a player sprite
; In: A: sprite attribute offset
;     BC: D = Y, E = X
print_sprite_at_location:
        push af

        ld a,e
        add a,a
        add a,a
        add a,a
        add a,a
        add a,8
        ld h,a
        
        ld a,d
        add a,a
        add a,a
        add a,a
        add a,a
        ld l,a
        pop af
        call update_sprite_attributes
        ret


; Update sprite attributes for the set of sprites to display a skooter
; In: A: sprite attribute offset
;     HL: L = Y, H = X
update_sprite_attributes:
        ld d,$1b
        ld e,a

        ld (sprite_attributes),hl
        
        ld a,16
        add a,l
        ld l,a

        ld (sprite_attributes + 4),hl

        ld hl,sprite_attributes
        ld bc,8
        call LDIRVM
        ret

sprite_attributes:
        db 168,240,0,15
        db 184,240,4,14

