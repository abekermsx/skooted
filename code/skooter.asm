	

run_skooter:
        call is_escape_pressed
        jr z,run_skooter

        ; overwrite the LD SP,$F000 with NOPs
        ld hl,0
        ld (SKOOTER.INITIALIZE_SP),hl
        ld (SKOOTER.INITIALIZE_SP + 1),hl

        ; Update call address so we can intercept ESC key in selector screen
        ld hl,exit_skooter_selector
        ld (SKOOTER.CALL_HANDLE_SELECTOR_CHOICES + 1),hl

        ; Update call address so we can intercept ESC key in title screen and gameplay
        ld hl,exit_skooter_title_and_gameplay
        ld (SKOOTER.CALL_UPDATE_STATE + 1),hl

        ; Set up a call to a custom routine to set the sheet number when starting the game
        ld a,$cd
        ld (SKOOTER.INITIALIZE_SHEET_NUMBER),a    
        ld hl,set_sheet_number
        ld (SKOOTER.INITIALIZE_SHEET_NUMBER+1),hl

        ; set the number of lives to 42
        ld a,42
        ld (SKOOTER.LIVES),a

        ; reset RAM to prevent sprites to be displayed on
        ld hl,SKOOTER.RAM_VARIABLES
        ld bc,$c00
        xor a
        call fill_ram
        
        ld hl,HKEYI
        ld de,HKEYI_backup
        ld bc,5
        ldir

        ld (SP_backup),sp

        ld hl,($4002)
	jp (hl)

end_skooter:
        di
        ld sp,(SP_backup)

        ld hl,HKEYI_backup
        ld de,HKEYI
        ld bc,5
        ldir

        call GICINI
        ret


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


SP_backup:
        dw 0

HKEYI_backup:
        ds 5
