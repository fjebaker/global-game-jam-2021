;states
;state HOME = strart screen
;state IN-GAME = in game
;state PAUSE = pause screen
;state END-L = lose screen
;state END-W = win screen
;state RESET = start a new game
;state HELP = help info within start menu
;state CREDS = credits screen

;initialise to be start screen
(var current "HOME")

{
    :current current
}