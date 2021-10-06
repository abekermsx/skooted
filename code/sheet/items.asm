
; Check if there's an item at the specified location
; In: DE: D = Y, E = X
is_item_at_location:
        ld bc,SHEET.ITEMS
        jp is_object_at_location


; Remove an item at specified location
; In: DE: D = Y, E = X
remove_item_at_location:
        call is_item_at_location
        ret z

        ld bc,SHEET.ITEMS
        call remove_object
        ret
