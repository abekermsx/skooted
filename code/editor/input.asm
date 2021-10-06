
; Get input from keyboard/joysticks
; Out: A: result
get_input:
        ld b,3
get_input_stick_check:
        ld a,b
        dec a
        push bc
        call GTSTCK
        pop bc
        or a
        ret nz
        djnz get_input_stick_check

        xor a
get_input_fire1_check:
        ld b,a
        push bc
        call GTTRIG
        pop bc
        or a
        jr nz,get_input_fire1
        ld a,b
        add a,a
        inc a
        cp 4
        jr nc,get_input_fire1_check

        ld b,4
get_input_fire2_check:
        ld a,b
        push bc
        call GTSTCK
        pop bc
        or a
        jr nz,get_input_fire2
        dec b
        djnz get_input_fire2_check

        ld a,7
        call SNSMAT
        bit 1,a
        jr z,get_input_f5
        bit 2,a
        jr z,get_input_esc
        bit 5,a
        jr z,get_input_bs

        ld a,8
        call SNSMAT
        bit 3,a
        jr z,get_input_del

        ld a,6
        call SNSMAT
        bit 5,a
        jr z,get_input_f1
        bit 6,a
        jr z,get_input_f2

        xor a
        ret

get_input_fire1:
        ld a,INPUT.FIRE1
        ret

get_input_fire2:
        ld a,INPUT.FIRE2
        ret

get_input_esc:
        ld a,INPUT.ESC
        ret

get_input_bs:
get_input_del:
        ld a,INPUT.DEL
        ret

get_input_f1:
        ld a,INPUT.F1
        ret

get_input_f2:
        ld a,INPUT.F2
        ret

get_input_f5:
        ld a,INPUT.F5
        ret


; Check if ESC is pressed
; Out: A: 0 if pressed, non-zero if not pressed
is_escape_pressed:
        ld a,7
        call SNSMAT
        and 4
        ret


; Wait for the release of pressed keys/sticks/buttons
; In: HL: pointer to routine used to blink item in current editor
wait_release:
        ld b,12

wait_release2:
        ld (wait_release_blink+1),hl

wait_release_loop:
        push bc

        call jiffy_wait
wait_release_blink:
        call $ffff

        call get_input
        pop bc
        or a
        ret z
        djnz wait_release_loop
wait_release_dummy:
        ret

