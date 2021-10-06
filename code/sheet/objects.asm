

; Check if there's on object at the specified location
; In: DE: D = Y, E = X
;     BC: object data offset in sheet
; Out: A: object number (0 = no object, 1 = first object, ...)
is_object_at_location:
        ld hl,(sheet_pointer)
        add hl,bc
        ld b,4

is_object_at_location_loop:
        ld a,(hl)
        inc hl
        cp e
        ld a,(hl)
        inc hl
        jr nz,is_object_at_location_next
        cp d
        jr nz,is_object_at_location_next

        ld a,5
        sub b
        ret

is_object_at_location_next:
        djnz is_object_at_location_loop
        xor a
        ret


; Remove an object
; In: BC: object data offset in sheet
;     A: object number (1=first object,...)
remove_object:
        dec a
        call calculate_object_address
        ld (hl),$ff
        inc hl
        ld (hl),$ff
        ret


; Remove all objects
remove_objects:
        ld hl,(sheet_pointer)
        ld bc,SHEET.ITEMS
        add hl,bc
        ld bc,3 * 8
        ld a,255
        call fill_ram
        ret
        

; Get object location
; In: A: object number (0 = first object)
;     BC: object data offset in sheet
; Out: D = Y, E = X
get_object_location:
        call calculate_object_address
        
        ld e,(hl)
        inc hl
        ld d,(hl)
        ret


; Calculates address of object in sheet data
; In: BC: object data offset in sheet
;     A: object number (0=first object)
calculate_object_address:
        ld hl,(sheet_pointer)
        add hl,bc
        add a,a
        ld c,a
        add hl,bc
        ret
