

; In: A: level number
initialize_patterns:
        push af
        call initialize_patterns_block0
        call initialize_enemy_patterns
        call initialize_enemy_colors
        pop af
        push af
        call initialize_item_patterns
        pop af
        call initialize_item_colors
        call initialize_heart_pattern
        call initialize_heart_colors
        ret

initialize_patterns_block0:
        dec a
        add a,a
        add a,a
        add a,a
        add a,a

; initialize top patterns of block 0
        ld h,$98
        ld l,a
        ld de,$8000 + 4 * 32 * 8
        ld bc,16
        ldir
	
; initialize bottom patterns of block 0
        ld h,$99
        ld l,a
        ld de,$8000 + 5 * 32 * 8
        ld bc,16
        ldir
        ret


initialize_enemy_patterns:
        ld b,4
        xor a
initialize_enemy_patterns_loop:
        push bc
        
        ld hl,$9D60

; initialize top left pattern of enemy
        ld de,$8000 + 4 * 32 * 8 + 24 * 8
        call initialize_enemy_patterns_content
	
; initialize bottom left pattern of enemy
        ld de,$8000 + 5 * 32 * 8 + 24 * 8
        call initialize_enemy_patterns_content

; initialize top right pattern of enemy
        ld de,$8000 + 4 * 32 * 8 + 8 + 24 * 8
        call initialize_enemy_patterns_content

; initialize bottom right pattern of enemy
        ld de,$8000 + 5 * 32 * 8 + 8 + 24 * 8
        call initialize_enemy_patterns_content

        pop bc
        add a,16
        djnz initialize_enemy_patterns_loop
        ret

initialize_enemy_patterns_content:
        ld b,a
        add a,e
        ld e,a
        ld a,b
        ld bc,8
        ldir
        ret


initialize_enemy_colors:
        ld hl,$8800 + 4 * 32 * 8 + 24 * 8
        call initialize_enemy_colors_row
        
        ld hl,$8800 + 5 * 32 * 8 + 24 * 8
        call initialize_enemy_colors_row
        ret

initialize_enemy_colors_row:        
        ld d,h
        ld e,l
        inc e
        
        ld a,$a0
        call initialize_enemy_colors_row_content2
        ld a,$d0
        call initialize_enemy_colors_row_content
        ld a,$50
        call initialize_enemy_colors_row_content
        ld a,$30
        call initialize_enemy_colors_row_content
        ret


initialize_enemy_colors_row_content:
        inc l
        inc e
initialize_enemy_colors_row_content2:
        ld (hl),a
        ld bc,15
        ldir
        ret


initialize_item_patterns:
        ld h,$90
        call get_item_offset
        
        push hl

; initialize top patterns of items
        ld de,$8000 + 4 * 32 * 8 + 16 * 8
        ld bc,64
        ldir
	
; initialize bottom patterns of items
        pop hl
        inc h
        ld de,$8000 + 5 * 32 * 8 + 16 * 8
        ld bc,64
        ldir
        ret


initialize_item_colors:
        ld h,$94
        call get_item_offset

        push hl

; initialize top patterns of items
        ld de,$8800 + 4 * 32 * 8 + 16 * 8
        ld bc,64
        ldir
	
; initialize bottom patterns of items
        pop hl
        inc h
        ld de,$8800 + 5 * 32 * 8 + 16 * 8
        ld bc,64
        ldir
        ret

initialize_heart_pattern:
        ld hl,heart_data
        ld de,$8000 + 7 * 32 * 8 + 31 * 8
        ld bc,8
        ldir
        ret

heart_data:
        db %00000000
        db %01101100
        db %11111110
        db %11111110
        db %01111100
        db %00111000
        db %00010000
        db %00000000

initialize_heart_colors:
        ld hl,$8800 + 2048 - 8
        ld bc,8
        ld a,$90
        call fill_ram
        ret

; In: A: level number
;     H: base address
get_item_offset:
        dec a
        cp 8
        jr c,get_item_offset1
        inc h
        inc h
        sub 8
get_item_offset1:
        srl a
        rrca
        rrca
        ld l,a
        ret
