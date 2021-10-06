
; Get the pattern at the specified location
; In: D = Y, E = X
; Out: A: pattern
;      HL: address in sheet
get_pattern_at_location:
        call calculate_map_address
        ld a,(hl)
        ret
        

; Set a pattern at the specified location
; In: D = Y, E = X
;     A: pattern
set_pattern_at_location:
        push af
        call calculate_map_address
        pop af
        ld (hl),a
        ret


; Get the address of a tile position in the map
; In: D = Y, E = X
; Out: HL: address in sheet
calculate_map_address:
        ld a,d
        add a,a ; Y*2
        add a,a ; Y*4
        add a,a ; Y*8
        add a,d ; Y*9
        add a,d ; Y*10
        add a,d ; Y*11
        add a,e ; add X
        
        ld hl,(sheet_pointer)
        inc hl
        inc hl
        add a,l
        ld l,a
        ret nc
        inc h
        ret
