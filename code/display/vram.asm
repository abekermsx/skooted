
initialize_vram_patterns:
        ; patterns block 0
        ld de,0
        call initialize_vram_patterns_bank
		
        ; patterns block 1
        ld de,2048
        call initialize_vram_patterns_bank
		
        ; patterns block 2
        ld de,4096
        call initialize_vram_patterns_bank

        ; colors block 0
        ld de,8192
        call initialize_vram_colors_bank

        ; colors block 1
        ld de,8192 + 2048
        call initialize_vram_colors_bank

        ; colors block 2
        ld de,8192 + 4096
        call initialize_vram_colors_bank

        ; copy top player sprite pattern
        ld hl,$9b60
        ld de,$3800
        ld bc,32
        push bc
        call LDIRVM
        pop bc
        
        ; copy bottom player sprite pattern
        ld hl,$9b80
        ld de,$3820
        call LDIRVM
        ret

; Initialize the patterns in the specified bank
; In: DE: bank address
initialize_vram_patterns_bank:
        ld hl,$8000
initialize_vram_bank:
        ld bc,2048
        call LDIRVM
        ret


; Initialize the colors in the specified bank
; In: DE: bank address
;     BC: number of bytes to transfer
initialize_vram_colors_bank:
        ld hl,$8800
        jr initialize_vram_bank
