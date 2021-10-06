
; Check if there's an heart at the specified location
; In: DE: D = Y, E = X
is_heart_at_location:
        ld bc,SHEET.HEARTS
        jp is_object_at_location


; Remove a heart at specified location
; In: DE: D = Y, E = X
remove_heart_at_location:
        call is_heart_at_location
        ret z

        ld bc,SHEET.HEARTS
        call remove_object
        ret


; Get heart location in map
; In: A: heart number
; Out: DE: D = Y, E = X
get_heart_location:
        ld bc,SHEET.HEARTS
        call get_object_location
        ret


; Put a heart on the map
; In: A: heart number
;     DE: D = Y, E = X
put_heart_at_location:
        call calculate_heart_address
        ld (hl),e
        inc hl
        ld (hl),d
        ret


; Calculates address of heart in sheet data
; In: A: object number (0=first object)
calculate_heart_address:
        ld bc,SHEET.HEARTS
        call calculate_object_address
        ret
