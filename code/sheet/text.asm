

update_sheet_text:
        call text_to_messages
        push bc ; push messages length
        call calculate_message_size_change
        push bc ; push size change
        call update_sheet_pointers
        pop bc  ; pop size change
        call move_sheet_data
        pop bc  ; pop messages length
        call copy_message_to_sheet
        ret

; Converts the screen to a series of text messages
; Out: BC: messages length
text_to_messages:
        ld hl,6144 + 2 * 32
        ld de,sheet_message
        ld bc,(24 - 2) * 256 + 2

text_to_messages_line:
        push bc
        call text_line_to_message
        pop bc
        inc c
        djnz text_to_messages_line

        ld a,255
        ld (de),a       ; End of message
        inc de

        ex de,hl
        ld de,sheet_message
        or a
        sbc hl,de

        ld c,l
        ld b,h
        ret

text_line_to_message:
        ld b,32

text_line_to_message_loop:
        call RDVRM
        cp ' '
        jr nz,text_line_to_message_append
        inc hl
        djnz text_line_to_message_loop
        ret

text_line_to_message_append:
        ld a,32
        sub b
        ld (de),a       ; Set the X position of the string
        inc de
        ld a,c
        ld (de),a       ; Set the Y position of the string
        inc de

text_line_to_message_append_character:
        call RDVRM
        ld (de),a
        inc hl
        inc de
        djnz text_line_to_message_append_character

text_line_to_message_trim:
        dec de
        ld a,(de)
        cp ' '
        jr z,text_line_to_message_trim

        inc de
        xor a
        ld (de),a       ; End of string
        inc de
        ret


; Compact all the sheets to free space wasted by the default texts
; Not the most efficient way to do it but doesn't require extra code
compact_sheet_texts:
        ld b,16
compact_sheet_texts_loop:
        push bc

        ld a,b
        ld (sheet_number),a
        call get_sheet_address
        ld (sheet_pointer),hl
        
        call clear_text_area

        ld hl,(sheet_pointer)
        ld bc,SHEET.TEXT
        add hl,bc
        ex de,hl
        call display_message

        call update_sheet_text

        pop bc
        djnz compact_sheet_texts_loop
        ret


sheet_message:  equ $c000
