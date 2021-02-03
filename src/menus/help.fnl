; IMPORTS
(local Menu (require :src.menu))
(local state (require :src.state))

(local help-text "Help I'm a beetle?
You have awoken as a beetle in a foreign world you once knew.
Now feeling lost and vulnerable, you must find food and a way to escape
this domestic prison...\n
Controls
Use 'W-A-S-D' or arrow keys crawl to freedom.")

; METHODS

(fn back_func [] (set state.current "PAUSE"))

; CONSTRUCTOR

(fn new []
    (let [buttons []
          texts []
          font (love.graphics.newFont "assets/fonts/NugoSansLight-9YzoK.ttf" 20)]
        (tset buttons 1 (Menu.newbutton "Back to Menu - (enter)" back_func))

        (tset texts 1 (Menu.newtext "Kafkaesque - Pause Menu - Help." [100 50]))
        (tset texts 2 (Menu.newtext help-text [100 200] font))

        (Menu.new {
                :image "assets/help_menu_bg.png"
                :img-x -300
                :img-y -210
                :img-scale 1.3
                :texts texts
                :buttongroup (Menu.newbuttongroup buttons [95 500])
            }
        )
    )
)

; MODULE EXPORTS
{:new new}
