
exit_skooter_selector:
        call SKOOTER.HANDLE_SELECTOR_CHOICES
        ret c

        call is_escape_pressed
        jr z,end_skooter
        ret


exit_skooter_title_and_gameplay:
        push af
        push bc
        
        call is_escape_pressed
        jr z,end_skooter       

        pop bc
        pop af
        call SKOOTER.UPDATE_STATE
        ret

set_sheet_number:
        ld a,(sheet_number)
        dec a
        ld (SKOOTER.SHEET_NUMBER),a
        xor a
        ret
