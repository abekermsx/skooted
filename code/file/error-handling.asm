
init_disk_error_handler:
        ld hl,error_pointer
        ld (DISKVE),hl
        ret

error_pointer:
        dw bdos_error_handler


bdos_wrapper:
        push af
        xor a
        ld (bdos_error),a
        pop af
        ld (bdos_stack),sp
        call BDOSBAS
        ret

bdos_error_handler:
        ld sp,(bdos_stack)

        ld a,c
        ld (bdos_error_code),a
        
        ld a,(RAMAD1)
        ld h,$40
        call ENASLT
        
        ld a,255
        ld (bdos_error),a
        ret

bdos_stack:
        dw 0
bdos_error:
        db 0
bdos_error_code:
        db 0
