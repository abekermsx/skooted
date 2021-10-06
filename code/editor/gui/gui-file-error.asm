
gui_file_error:
        ld a,(bdos_error_code)

        and %1110
        ld de,gui_error_disk_write_protected
        jr z,gui_file_error_display

        cp 2
        ld de,gui_error_disk_offline
        jr z,gui_file_error_display

        ld de,gui_error_disk_error

gui_file_error_display:
        call display_error_message
        jp gui_file_action


gui_error_disk_write_protected:
        db 24, "Disk is write protected!"

gui_error_disk_offline:
        db 12, "Insert disk!"

gui_error_disk_error:
        db 11, "Disk error!"
