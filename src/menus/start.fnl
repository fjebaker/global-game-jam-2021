; IMPORTS
(local Menu (require :src.menu))
(local state-machine (require :src.state))

; METHODS

(fn play_func [] (state-machine:switch :RESET))
(fn quit_func [] (love.event.quit 0))
(fn creds_func [] (state-machine:switch :CREDS))

; CONSTRUCTOR

(fn new []
    (let [buttons []]
        (tset buttons 1 (Menu.newbutton "Wake Up. - play" play_func))
        (tset buttons 2 (Menu.newbutton "Stay Asleep. - quit" quit_func))
        (tset buttons 3 (Menu.newbutton "Credits." creds_func))

        (Menu.new {
                :image "assets/start_menu_bg.png"
                :img-scale 0.7
                :texts [(Menu.newtext "Kafkaesque - Start Menu." [100 50])]
                :buttongroup (Menu.newbuttongroup buttons [95 200])
            }
        )
    )
)

; MODULE EXPORTS
{:new new}
