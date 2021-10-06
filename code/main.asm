
        DEVICE NOSLOT64K
        OUTPUT "../output/SKOOTED.BIN"
		
        include "system/MSX-DOS.equ.z80"
        include "system/MSXBIOS.equ.z80"
        include "system/MSXhooks.equ.z80"
        include "system/MSXvars.equ.z80"
	
        include "constants.asm"

        org $c000 - 7

header: db $fe
        dw start, end, entry
		
start:

page2_start:
        PHASE $b000

        include "display/border.asm"
        include "display/display.asm"
        include "display/gui.asm"
        include "display/message.asm"
        include "display/patterns.asm"
        include "display/sheet.asm"
        include "display/sprites.asm"
        include "display/text.asm"
        include "display/vdp.asm"
        include "display/vram.asm"

        include "editor/input.asm"

        include "editor/gui/gui.asm"
        include "editor/gui/gui-blocks.asm"
        include "editor/gui/gui-file-action.asm"
        include "editor/gui/gui-file-error.asm"
        include "editor/gui/gui-file-load.asm"
        include "editor/gui/gui-file-name.asm"
        include "editor/gui/gui-file-save.asm"
        include "editor/gui/gui-file-select.asm"
        include "editor/gui/gui-player-hearts.asm"
        include "editor/gui/gui-sheet-error.asm"
        include "editor/gui/gui-sheet-number.asm"
        include "editor/gui/gui-text.asm"

        include "editor/sheet/edit.asm"
        include "editor/sheet/edit-hearts.asm"
        include "editor/sheet/edit-player.asm"
        include "editor/sheet/edit-sheet.asm"

        DEPHASE
page2_end:

entry:
	call load_skooter
        or a
        jr nz,terminate

        ld hl,FNKSTR
        ld bc,160
        call fill_ram

        call init_disk_error_handler
        
        ld hl,page2_start
        ld de,$b000
        ld bc,page2_end - page2_start
        ldir

        call initialize_vdp

        call jiffy_wait
        call DISSCR
        call compact_sheet_texts
main_loop:
        call display_screen

        call gui
        
        call run_skooter
        jr main_loop

terminate:
        ld c,_STROUT
        ld de,skooter_not_found_message
        call BDOSBAS
        ret

skooter_not_found_message:
        db "Please put a copy of SKOOTER.ROM on the same disk as this editor.$"


        include "helpers.asm"
        include "skooter.asm"

        include "file/error-handling.asm"
        include "file/fcb.asm"
        include "file/helpers.asm"
        include "file/load-sheets.asm"
        include "file/load-skooter.asm"
        include "file/save-sheets.asm"
        include "file/search-sheets.asm"

        include "sheet/enemies.asm"
        include "sheet/hearts.asm"
        include "sheet/items.asm"
        include "sheet/map.asm"
        include "sheet/objects.asm"
        include "sheet/player.asm"
        include "sheet/sheet.asm"
        include "sheet/text.asm"

; Skooter uses RAM in $c000-$cbff (approximately), ensure all code from main_loop onwards isn't overwritten
        ASSERT main_loop >= $cc00

; Area $7000-$7bff can be overwritten with the editor code
        ASSERT (page2_end - page2_start) <= $1000

end:
