;states
;state HOME = strart screen
;state IN-GAME = in game
;state PAUSE = pause screen
;state END = win-lose screen
;state RESET = start a new game
;state HELP = help info within start menu

;initialise to be start screen
(var current "HOME")

{
    :current current
}