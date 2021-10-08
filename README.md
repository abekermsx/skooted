# Skooter Editor
Skooter is a cute puzzle/action game for MSX made by Ronald Pieket Weeserik in 1987. It features 16 levels (which are called sheets in Skooter) in which the player has to collect all the fruits and avoid contact with the enemies.

Skooter Editor (SKOOTED) is a program in which you can create, play and share your own sheets. Download 

# How to run
Download the release from https://github.com/abekermsx/skooted/releases/tag/v1.0 and copy SKOOTED.BIN to your MSX. 

SKOOTED can be started from BASIC by typing in the code below:\
BLOAD "SKOOTED.BIN",R

SKOOTED requires a copy of a ROM-image of SKOOTER which must be located on the same disk (and directory) as SKOOTED. The filename has to be SKOOTER.ROM.

There are many different releases of Skooter, but not all of them can be used with SKOOTED. SKOOTED works with versions that have one of the following CRC32 checksums:\
F9E0FB4C\
5A67D705

Most other versions of Skooter are very different from these ones and will not work.

# How to control
F1: Start the game from the current sheet (all sheets must be valid)\
F2: Enter the message editor\
F5: Clear sheet or messages\
Esc: Leave sheet editor, message editor, file selector\
Up/Down/Left/Right: Move cursor in sheet editor, message editor or selection in GUI\
Space: Perform action in GUI, select element in GUI or put element in sheet\

SKOOTED has limited support for joysticks. Fire button 1 works as Space, Fire button 2 works as Esc. It's not possible to enter a filename or edit the messages using a joystick.

# Compatibility
Skooter Editor should run on any MSX1 and higher with at least 64KB RAM and a diskdrive.

# Notes
- The code can be assembled using sjasmplus ( https://github.com/z00m128/sjasmplus )
- I used the "MSX constants (EQUs) for assembly development by FRS" ( http://frs.badcoffee.info/tools.html ). These are public domain
- Various resources and articles were used as a reference
  - http://map.grauw.nl/resources/msxbios.php
  - http://map.grauw.nl/articles/dos-error-handling.php
  - http://map.grauw.nl/articles/keymatrix.php
  - http://map.grauw.nl/resources/dos2_functioncalls.php
  - https://konamiman.github.io/MSX2-Technical-Handbook/md/Appendix1.html
