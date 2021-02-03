; IMPORTS
(local Menu (require :src.menu))
(local state (require :src.state))

; METHODS

(fn play_func [] (set state.current "IN-GAME"))
(fn help_func [] (set state.current "HELP"))
(fn quit_func [] (set state.current "HOME"))

; CONSTRUCTOR

(fn new []
    (let [buttons []]
        (tset buttons 1 (Menu.newbutton "Resume..." play_func))
        (tset buttons 2 (Menu.newbutton "help me Im a beetle?" help_func))
        (tset buttons 3 (Menu.newbutton "Quit."  quit_func))

        (Menu.new {
                :image "assets/pause_menu_bg.jpg"
                :img-scale 0.863
                :texts [(Menu.newtext "Kafkaesque - Pause Menu." [100 50])]
                :buttongroup (Menu.newbuttongroup buttons [95 200])
            }
        )
    )
)

; MODULE EXPORTS
{:new new}
