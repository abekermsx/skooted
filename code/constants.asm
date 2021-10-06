
GUI.UP:         equ 1
GUI.DOWN:       equ 2
GUI.PLAY:       equ 3
GUI.SHEET:      equ 4
GUI.PLAYER:     equ 5
GUI.HEARTS:     equ 6
GUI.CLEAR:      equ 7
GUI.TEXT:       equ 8

SPRITE.GUI:     equ 0
SPRITE.PLAYER:  equ 8
SPRITE.CURSOR:  equ 16

INPUT.UP:       equ 1
INPUT.RIGHT:    equ 3
INPUT.DOWN:     equ 5
INPUT.LEFT:     equ 7
INPUT.FIRE1:    equ 9
INPUT.FIRE2:    equ 10
INPUT.ESC:      equ 11
INPUT.DEL:      equ 12
INPUT.F1:       equ 13
INPUT.F2:       equ 14
INPUT.F5:       equ 15

SHEETS.MAXIMUM: equ 18

SKOOTER.INITIALIZE_SP:                  equ $4015
SKOOTER.UPDATE_STATE:                   equ $415D
SKOOTER.LIVES:                          equ $42C0
SKOOTER.INITIALIZE_SHEET_NUMBER:        equ $42B9
SKOOTER.CALL_HANDLE_SELECTOR_CHOICES:   equ $4350
SKOOTER.CALL_UPDATE_STATE:              equ $5A40
SKOOTER.HANDLE_SELECTOR_CHOICES:        equ $5E64
SKOOTER.SHEETS:                         equ $659F
SKOOTER.RAM_VARIABLES:                  equ $C000
SKOOTER.SHEET_NUMBER:                   equ $C3BD

        STRUCT SHEET
POINTER WORD            ; pointer to next sheet
MAP     BLOCK 121       ; map of 11x11 tiles
PLAYER  BLOCK 2         ; X/Y
ITEMS   BLOCK 8         ; 4x X/Y combinations
HEARTS  BLOCK 8         ; 4x X/Y combinations
ENEMIES BLOCK 8         ; 4x X/Y combinations
UNKNOWN BLOCK 1         ; ?
TEXT    BYTE            ; actual size depends on the level 
        ENDS
