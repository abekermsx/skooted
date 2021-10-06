
display_screen:
        call jiffy_wait
        call DISSCR

        ld a,(sheet_number)
        call get_sheet_address
        ld (sheet_pointer),hl

        call CLRSPR

        ld a,(sheet_number)
        call initialize_patterns

        call initialize_vram_patterns

        call initialize_border

        call print_sheet
        call print_player_sprite
		
        call initialize_gui
        
        call jiffy_wait
        call ENASCR
        ret
