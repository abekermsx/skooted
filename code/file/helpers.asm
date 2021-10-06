
open_file:
        call clear_fcb
        
        ld de,fcb
        ld c,_FOPEN
        call bdos_wrapper

        or a
        ret nz
        
        call initialize_fcb
        xor a
        ret

close_file:
        ld de,fcb
        ld c,_FCLOSE
        call bdos_wrapper
        ret
