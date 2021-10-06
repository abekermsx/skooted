
gui_sheet_error:
        ld de,gui_sheet_error_message
        call display_error_message
        ret

gui_sheet_error_message:
        db 24, "Invalid sheets detected!"
