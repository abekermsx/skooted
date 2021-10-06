
; In: A: level number
get_sheet_address:
        ld hl,SKOOTER.SHEETS

get_sheet_address_loop:
        dec a
        ret z
        ld c,(hl)
        inc hl
        ld h,(hl)
        ld l,c
        jr get_sheet_address_loop


; Update all the sheet pointers
; In: BC: sheet size change
update_sheet_pointers:
        ld hl,(sheet_pointer)

        exx
        ld a,(sheet_number)
        ld b,a
        ld a,17
        sub b
        ld b,a
update_sheet_pointers_loop:
        exx
        
        ld e,(hl)
        inc hl
        ld d,(hl)
        
        push de
        
        ex de,hl
        add hl,bc
        ex de,hl

        ld (hl),d
        dec hl
        ld (hl),e

        pop hl

        exx
        djnz update_sheet_pointers_loop
        exx
        ret


; Move the sheet data to make space for longer texts, or remove space
; In: BC: amount of bytes to expand/shrink
move_sheet_data:
        ld a,b
        or c
        ret z

        ld a,(sheet_number)
        cp 16
        ret z

        ld hl,(sheet_pointer)
        ld e,(hl)
        inc hl
        ld d,(hl)       ; DE: The new address of the next sheet

        ld h,d
        ld l,e
        or a
        sbc hl,bc       ; HL: The old address of the next sheet

        push hl
        ld hl,$8000
        sbc hl,de

        ld a,b
        and 128
        jr z,move_sheet_data_expand

move_sheet_data_shrink:
        ld c,l
        ld b,h
        pop hl
        ldir 
        ret

move_sheet_data_expand:
        sbc hl,bc
        ld c,l
        ld b,h
        pop hl
        add hl,bc
        dec hl
        ex de,hl
        add hl,bc
        dec hl
        ex de,hl
        lddr
        ret


; Copy the new message to the sheet
; In: BC: message length
copy_message_to_sheet:
        ld hl,(sheet_pointer)
        ld de,SHEET.TEXT
        add hl,de
        ex de,hl
        ld hl,sheet_message
        ldir
        ret


; In: BC: length of the new message
; Out: BC: size change
calculate_message_size_change:
        ld hl,(sheet_pointer)

        ld e,(hl)
        inc hl
        ld d,(hl)
        dec hl
        ex de,hl
        or a
        sbc hl,de   ; current sheet length
        ld de,SHEET.TEXT
        sbc hl,de   ; length of the current text

        push bc
        push hl
        pop de
        pop hl
        sbc hl,de   ; change in text size
        ld b,h
        ld c,l
        ret


; Clear sheet
clear_sheet:
        ld hl,(sheet_pointer)
        inc hl
        inc hl
        ld bc,11 * 11
        xor a
        call fill_ram

        call remove_objects

        ld de,5 * 256 + 5
        call set_player_location
        ret


; Validate all sheets
; All sheets must contain all 4 enemies and all 4 items to be playable
; Out: A: 0 = all sheets valid
validate_sheets:
        ld hl,SKOOTER.SHEETS
        ld b,16

validate_sheets_loop:
        push bc
        push hl
        ld bc,SHEET.ITEMS
        call validate_objects
        pop hl
        pop bc

        or a
        ret nz

        push bc
        push hl
        ld bc,SHEET.ENEMIES
        call validate_objects
        pop hl
        pop bc

        or a
        ret nz

        ld e,(hl)
        inc hl
        ld h,(hl)
        ld l,e

        djnz validate_sheets_loop
        xor a
        ret


; Validate existence of objects
; In: HL: sheet pointer
;     BC: offset to item data
; Out: A: 0 = all objects valid
validate_objects:
        add hl,bc
        ld b,4

validate_objects_loop:
        ld a,(hl)
        inc a
        jr z,validate_objects_error
        inc hl
        inc hl
        djnz validate_objects_loop
        xor a
        ret

validate_objects_error:
        ld a,255
        ret


sheet_lengths: equ $c400
