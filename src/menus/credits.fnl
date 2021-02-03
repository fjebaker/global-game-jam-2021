; IMPORTS
(local Menu (require :src.menu))
(local state (require :src.state))

(local credits "Authors:
dustpancake, jwiggins & shellywell123

We would like to thank the following people:

dustpancake & shellywell123 for the Art & Music
William Lawson for the voice acting
Franz Kafka for the inspiration.")

; METHODS

(fn git_func []
    (love.system.openURL "https://github.com/dustpancake/global-game-jam-2021")
)

(fn fonts_func []
    (love.system.openURL "https://www.fontspace.com/a-agreement-signature-font-f52534")
    (love.system.openURL "https://www.fontspace.com/nugo-sans-font-f52173")
)

(fn wiki_func []
    (love.system.openURL "https://en.wikipedia.org/wiki/The_Metamorphosis")
)

(fn home_func [] (set state.current "HOME"))

; CONSTRUCTOR

(fn new []
    (let [buttons []
          texts []
          font (love.graphics.newFont "assets/fonts/NugoSansLight-9YzoK.ttf" 20)]
        (tset buttons 1 (Menu.newbutton "GitHub." git_func))
        (tset buttons 2 (Menu.newbutton "Fonts." fonts_func))
        (tset buttons 3 (Menu.newbutton "Metamorphosis?" wiki_func))
        (tset buttons 4 (Menu.newbutton "Back to Menu - (enter)" home_func))

        (tset texts 1 (Menu.newtext "Kafkaesque - Credits." [100 50]))
        (tset texts 2 (Menu.newtext credits [100 200] font))

        (Menu.new {
                :image "assets/start_menu_bg.png"
                :img-scale 0.7
                :texts texts
                :buttongroup (Menu.newbuttongroup buttons [95 400] nil 4)
            }
        )
    )
)

; MODULE EXPORTS
{:new new}
