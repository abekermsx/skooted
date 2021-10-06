
; Check if there's an enemy at the specified location
; In: DE: D = Y, E = X
is_enemy_at_location:
        ld bc,SHEET.ENEMIES
        jp is_object_at_location

; Remove an enemy at specified location
; In: DE: D = Y, E = X
remove_enemy_at_location:
        call is_enemy_at_location
        ret z

        ld bc,SHEET.ENEMIES
        call remove_object
        ret
