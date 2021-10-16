
initialize_text_gui:
        call jiffy_wait
        call DISSCR

        call CLRSPR

        ld hl,6144
        ld bc,32 * 24
        ld a,' '
        call FILVRM

        ld hl,text_info_type
        ld de,6144 + 32 - 28
        ld bc,28
        CALL LDIRVM

        ld hl,(sheet_pointer)
        ld bc,SHEET.TEXT
        add hl,bc
        ex de,hl
        call display_message

        call update_sheet_text

        call gui_text_update_info

        call jiffy_wait
        call ENASCR
        ret


clear_text_area:
        ld hl,6144 + 2 * 32
        ld bc,32 * 22
        ld a,' '
        call FILVRM
        ret

; Put a character in the text area
; In: DE: location
;     A: character
set_text_character:
        push af
        call calculate_text_vram_address
        pop af
        call WRTVRM
        ret

; Get a character from the text area
; In: DE: location
; Out: A: character
get_text_character:
        call calculate_text_vram_address
        call RDVRM
        ret


; Shift text to the left
; In: A: number of characters to shift
;     DE: D = Y, E = X
shift_text:
        call calculate_text_vram_address
        ld b,a
        inc hl
        call RDVRM
        ld (gui_text_character),a
shift_text_loop:        
        call RDVRM
        dec hl
        call WRTVRM
        inc hl
        inc hl
        djnz shift_text_loop
        dec hl
        ld a,' '
        call WRTVRM
        ret


; In: DE: D = Y, E = X
calculate_text_vram_address:
        ld b,$18
        ld c,e

        ld l,d
        ld h,0
        call hl_times_32

        add hl,bc
        ret


; In: HL: amount of free space left
text_update_info:
        ld a,h
        and 128
        ld a,' '
        jr z,text_update_info1
        ld a,'-'
        ex de,hl
        ld hl,0
        sbc hl,de
text_update_info1:
        ld (text_info_data + 18),a
        ld de,text_info_data + 19
        call unsigned_int_to_ascii4

        ld a,(sheet_number)
        ld l,a
        ld h,0
        ld de,text_info_data
        call unsigned_int_to_ascii2

        ld hl,(gui_text_x)
        push hl
        inc l
        ld h,0
        ld de,text_info_data + 4
        call unsigned_int_to_ascii2
        pop hl

        ld l,h
        dec l
        ld h,0
        ld de,text_info_data + 8
        call unsigned_int_to_ascii2
        
        ld hl,text_info_data
        ld de,6144 + 32 + 9
        ld bc,23
        call LDIRVM
        ret


text_info_type:
        db "-SHEET- -X- -Y- -FREE SPACE-"

text_info_data:
        db      "00  00  00         0000"
