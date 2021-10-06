
initialize_border:
        ld a,138
        ld hl,6144
        call WRTVRM ; draw top left

        inc l

        ld bc,11 * 2
        ld a,140
        call FILVRM ; draw top

        ld hl,6144 + 1 + 11 * 2
        ld a,139
        call WRTVRM ; draw top right

        ld b,11 * 2
        ld hl,6144 + 32
initialize_border_loop:
        ld a,172
        call WRTVRM ; draw left
        ld de,11 * 2 + 1
        add hl,de
        ld a,172
        call WRTVRM ; draw right
        ld de,32 - 11 * 2 - 1
        add hl,de
        djnz initialize_border_loop

        ld a,170
        call WRTVRM ; draw bottom left

        inc l

        ld bc,11 * 2
        ld a,140
        call FILVRM ; draw bottom

        ld hl,6144 + 32 + 32 * 11 * 2 + 1 + 11 * 2
        ld a,171
        call WRTVRM ; draw bottom right
        ret
