


print_sheet:
        ld b,11
        ld d,0
initialize_sheet_rows:
        push bc
        ld e,0
        ld b,11

initialize_sheet_columns:
        push bc
        call print_pattern_xy
        pop bc
        
        inc e
        djnz initialize_sheet_columns

        pop bc
        inc d
        djnz initialize_sheet_rows
        ret


; Print a pattern at the specified location
; In: DE: D = Y, E = X
print_pattern_xy:
        call fill_pattern
        call output_pattern
        ret


; Fill the pattern buffer
; In: DE: D = Y, E = X
fill_pattern:
        call is_enemy_at_location
        jr nz,fill_pattern_enemy

        call is_item_at_location
        jr nz,fill_pattern_item

        call get_pattern_at_location

fill_pattern_value:        
        cp 16
        jr c,fill_pattern_walkable

fill_pattern_non_walkable:
        push af

        and $f0
        rrca
        rrca
        rrca
        rrca
        
        add a,a
        add a,128 + 64
        call fill_pattern_buffer

        pop af
        and $0f
        jr z,fill_pattern_non_walkable_maybe_heart

fill_pattern_on_blue_arrow:
        add a,a
        add a,128
        ld (pattern_buffer + 0),a
        inc a
        ld (pattern_buffer + 1),a

fill_pattern_non_walkable_maybe_heart:
        call is_heart_at_location
        ret z
        ld a,255
        ld (pattern_buffer + 0),a
        ret

fill_pattern_walkable:
        add a,a
        add a,128
        call fill_pattern_buffer
        ret

fill_pattern_buffer:
        ld l,a
        inc a
        ld h,a
        ld (pattern_buffer),hl
        add a,31
        ld l,a
        inc a
        ld h,a
        ld (pattern_buffer + 2),hl
        ret

fill_pattern_enemy:
        dec a
        add a,a
        add a,24 + 128
        call fill_pattern_buffer
        ret

fill_pattern_item:
        ld b,a
        ld a,4
        sub b   ; the patterns/colors for the items seem to be stored in reversed order
        add a,a
        add a,16 + 128
        call fill_pattern_buffer
        ret


; Output the pattern buffer to screen
; In: DE: D = Y, E = X
output_pattern:
        call calculate_tile_vram_address
        call output_pattern_buffer
        ret


; Output the pattern buffer to VRAM
; In: HL: VRAM address
output_pattern_buffer:
        ld a,(pattern_buffer + 0)
        call WRTVRM
        inc l
        ld a,(pattern_buffer + 1)
        call WRTVRM
        
        ld bc,32 - 1
        add hl,bc
        ld a,(pattern_buffer + 2)
        call WRTVRM
        inc l
        ld a,(pattern_buffer + 3)
        call WRTVRM
        ret


; Print a heart at specified location
; In: DE: D = Y, E = X
print_heart_at_location:
        call calculate_tile_vram_address
        ld bc,32 + 1
        add hl,bc
        ld a,255
        call WRTVRM
        ret


; In: DE: D = Y, E = X
calculate_tile_vram_address:
        ld b,0
        ld c,e

        ld h,b
        ld l,d

        call hl_times_64

        add hl,bc
        add hl,bc

        ld bc,6144 + 32 + 1
        add hl,bc
        ret


sheet_pointer:  dw 0
pattern_buffer: ds 4

