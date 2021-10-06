

initialize_gui:
        call initialize_gui_patterns
        call initialize_gui_sprites
        ret

initialize_gui_patterns:
        ld hl,gui_layout
        ld de,6144 + 24

initialize_gui_rows:
        ld bc,8

        ld a,(hl)
        sub 1
        ret c
        jr z,initialize_gui_empty_row
        dec a
        jr z,initialize_gui_increasing_row
        
        push bc
        push hl
        push de

        call LDIRVM

        pop de
        ld hl,32
        add hl,de
        ex hl,de

        pop hl
        pop bc
        add hl,bc
        jr initialize_gui_rows

initialize_gui_empty_row:
        inc hl
        ex de,hl
        call FILVRM
        ld bc,32
        add hl,bc
        ex de,hl
        jr initialize_gui_rows

initialize_gui_increasing_row:
        inc hl
        ld a,(hl)
        inc hl
        ld b,c
        ex de,hl
initialize_gui_increasing_row_loop:
        push af
        call WRTVRM
        pop af
        inc a
        inc hl
        djnz initialize_gui_increasing_row_loop
        ld c,32-8
        add hl,bc
        ex de,hl
        jr initialize_gui_rows


initialize_gui_sprites:
        ld a,SPRITE.GUI
        ld hl,240 * 256 + 168
        call update_sprite_attributes
        ret


; Hide a heart in the gui
; In: A: heart number
hide_heart:
        ld hl,6144 + 22 * 32 + 24 + 1
        
update_character:
        ld e,a
        ld d,0
        add hl,de
        xor a
        call WRTVRM
        ret

; Hide a filename character in the gui
; In: A: filename character index
hide_filename_character:
        ld hl,6144 + 32 * 1 + 24
        jr update_character


; Hide a file action text in the gui
; In: A: file action index
hide_file_action:
        add a,a
        add a,a
        add a,3 * 32 + 24
        ld l,a
        ld h,$18
        xor a
        ld bc,4
        call FILVRM
        ret

; Hide a filename
; In: A: filename index
hide_filename:
        ld de,6144 + 6 * 32 + 24
        ld l,a
        xor a
        ld h,a
        call hl_times_32
        add hl,de
        
        ld bc,8
        call FILVRM
        ret

hide_sprite:
        xor a
        ld l,209
        call update_sprite_attributes
        ret

; Print sheet number in the gui
; In: DE: digits
print_sheet_number:
        ld hl,6144 + 6 * 32 + 30
        ld a,d
        call WRTVRM
        inc hl
        ld a,e
        call WRTVRM
        ret


gui_layout:
        defb "  -FILE-"
        defb "........"
        defb 1
        defb "LOADSAVE"
        defb 1
        defb " -SHEET-"
gui_layout_sheet_number:
        defb "      01"
        defb 1
        defb "-BLOCKS-"
        defb 202,203,204,205,218,219,220,221
        defb 234,235,236,237,250,251,252,253
        defb 2,130 ;,131,132,133,134,135,136,137
        defb 2,162 ;,163,164,165,166,167,168,169
        defb 2,194 ;,195,196,197,198,199,200,201
        defb 2,226 ;,227,228,229,230,231,232,233
        defb 2,210 ;,211,212,213,214,215,216,217
        defb 2,242 ;,243,244,245,246,247,248,249
        defb 2,144 ;,145,146,147,148,149,150,151
        defb 2,176 ;,177,178,179,180,181,182,183
        defb 2,152 ;,153,154,155,156,157,158,159
        defb 2,184 ;,185,186,187,188,189,190,191
        defb 1
        defb " ",255,255,255,255,"   "
        defb 1
        defb 0
