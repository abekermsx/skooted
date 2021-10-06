

jiffy_wait:
        ei
        ld hl,JIFFY
        ld a,(hl)
jiffy_wait_loop:
        cp (hl)
        jr z,jiffy_wait_loop
        ret

; Jump to a function in a jump table
; In: HL: table with pointers to functions
;      A: function number (0-127)
; Destroys: AF, HL
jump_to_function:
        add a,a
        add a,l
        ld l,a
        jr nc,jump_to_function2
        inc h
jump_to_function2:
        ld a,(hl)
        inc hl
        ld h,(hl)
        ld l,a

jp_hl:  jp (hl)


; In HL: start address
;    BC: amount of bytes to fill
;    A: fill value
fill_ram:
        ld d,h
        ld e,l
        inc de
        dec bc
        ld (hl),a
        ldir
        ret


hl_times_64:
        add hl,hl       ; *64
hl_times_32:
        add hl,hl       ; *32
hl_times_16:
        add hl,hl       ; *16
        add hl,hl       ; *8
        add hl,hl       ; *4
        add hl,hl       ; *2
        ret


; Convert unsigned integer to ASCII string
; In: HL: unsigned integer
;     DE: location to put the ASCII string
unsigned_int_to_ascii:
unsigned_int_to_ascii5:
        ld	bc,-10000
	call	unsigned_int_to_ascii_digit
unsigned_int_to_ascii4:
	ld	bc,-1000
	call	unsigned_int_to_ascii_digit
unsigned_int_to_ascii3:        
	ld	bc,-100
	call	unsigned_int_to_ascii_digit
unsigned_int_to_ascii2:        
	ld	bc,-10
	call	unsigned_int_to_ascii_digit
	ld	c,b

unsigned_int_to_ascii_digit:
        ld	a,'0'-1
unsigned_int_to_ascii_digit_increase:
        inc	a
	add	hl,bc
	jr	c,unsigned_int_to_ascii_digit_increase
	sbc	hl,bc

	ld	(de),a
	inc	de
	ret
