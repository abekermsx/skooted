

; Display a message on screen
; In: DE: pointer to message
display_message:
        ld a,(de)
        cp 255
        ret z

        inc de
        
        ld c,a
        ld b,$18

        ld a,(de)
        ld l,a
        ld h,0
        call hl_times_32
        add hl,bc    

        inc de
display_message_text_loop:
        ld a,(de)
        inc de
        or a
        jr z,display_message

        call WRTVRM
        inc hl

        jr display_message_text_loop


; Display an error message on screen
; In: DE: pointer to message
display_error_message:
        call construct_message_box
        
        push de
        ld a,SPRITE.PLAYER
        ld hl,240 * 256 + 220
        call update_sprite_attributes
        pop de

        call display_message

display_error_message_wait_release:
        call get_input
        or a
        jr nz,display_error_message_wait_release

display_error_message_wait_press:
        call get_input
        or a
        jr z,display_error_message_wait_press

        call display_screen
        ret


; Create a message box that can be displayed with display_message
; In: DE: pointer to message
; Out: pointer to message box
construct_message_box:
        ld hl,message_box
        push hl
        
        push de
        push hl
        ld bc,3 * 32
        ld a,' '
        call fill_ram
        pop hl
        pop de

        ld a,(de)       ; get message length
        inc de
        ld c,a
        inc c
        inc c
        ld b,0
        
        ld a,32
        sub c
        rra             ; message X position

        ld (hl),a
        inc hl
        ld (hl),10
        inc hl
        add hl,bc
        ld (hl),b
        inc hl
        
        ld (hl),a
        inc hl
        ld (hl),11
        inc hl

        inc hl
        ex de,hl
        push bc
        dec c
        dec c
        ldir
        pop bc
        ex de,hl
        inc hl
        ld (hl),b
        inc hl
        
        ld (hl),a
        inc hl
        ld (hl),12
        inc hl
        add hl,bc
        ld (hl),b
        inc hl
        ld (hl),255

        pop de
        ret

message_box:        equ $c000
