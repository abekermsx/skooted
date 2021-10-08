
; Initializes skooter
init_skooter:
        call fix_skooter
        call patch_skooter
        ret


; Fix the PONY CANYON INC. release
fix_skooter:
        ld a,($4003)
        cp $7d  ; detect PONY CANYON INC. release
        ret nz

        ld hl,$4000 + $2af
        ld de,$4000
        ld bc,$8000 - $2af
        ldir
        ret


patch_skooter:
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
        ret
        