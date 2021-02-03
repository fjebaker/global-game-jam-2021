; IMPORTS
(local Menu (require :src.menu))
(local state (require :src.state))

(local kafka-words "``Slept, awoke, slept, awoke, miserable life''\n-Franz Kafka")
(local lose-text (.. "Kafkaesque - Fin. (You did not survive)\n\n" kafka-words))
(local win-text (.. "Kafkaesque - Fin. (You survived!)\n\n" kafka-words))
(local lose-image "assets/final_menu_lose_bg.png")
(local win-image "assets/final_menu_win_bg.png")

; METHODS

(fn home_func [] (set state.current "HOME"))

; CONSTRUCTOR

(fn new []
    (let [buttons []]
        (tset buttons 1 (Menu.newbutton "Back to Menu - (enter)" home_func))

        ; Decide which text/image to display
        (var text "")
        (var image "")
        (if (= state.current "END-L")
            (do
                (set text lose-text)
                (set image lose-image)
            )
            (= state.current "END-W")
            (do
                (set text win-text)
                (set image win-image)
            )
        )

        (Menu.new {
                :image image
                :img-scale 0.863
                :texts [(Menu.newtext text [100 50])]
                :buttongroup (Menu.newbuttongroup buttons [95 300])
            }
        )
    )
)

; MODULE EXPORTS
{:new new}
