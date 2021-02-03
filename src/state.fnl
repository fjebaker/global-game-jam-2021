; NOTE: It's dangerous to import in the outer scope of this module because
; it causes a circular dependency with other parts of the game.

; THE GAME
(var game nil)

; STATE ENTRANCES
(fn enter-in-game []
    (let [Kafkaesque (require :src.Kafkaesque)]
        (let [state (if (= nil game) (Kafkaesque.newgame) game)]
            (set game state)
            game
        )
    )
)

(fn enter-reset []
    (let [Kafkaesque (require :src.Kafkaesque)]
        (set game (Kafkaesque.newgame))
        game
    )
)

(fn enter-home []
    (let [Start (require :src.menus.start)]
        (Start.new)
    )
)


(fn enter-pause []
    (let [Pause (require :src.menus.pause)]
        (Pause.new)
    )
)

(fn enter-end []
    (let [Final (require :src.menus.final)]
        (Final.new)
    )
)

(fn enter-help []
    (let [Help (require :src.menus.help)]
        (Help.new)
    )
)

(fn enter-creds []
    (let [Credits (require :src.menus.credits)]
        (Credits.new)
    )
)

; METHODS
(fn init [self]
    (set self._current (enter-home))
)

(fn draw [self]
    (self._current:draw)
)

(fn keypressed [self key isrepeat]
    (self._current:keypressed key isrepeat)
)

(fn update [self dt]
    (self._current:update dt)
)

(fn switch [self name]
    (let [enter (. self name)]
        (set self.current name)
        (set self._current (enter))
    )
)

; The state machine
(local instance {
    :HOME enter-home  ; strart screen
    :IN-GAME enter-in-game  ; in game
    :PAUSE enter-pause  ; pause screen
    :END-L enter-end  ; lose screen
    :END-W enter-end  ; win screen
    :RESET enter-reset  ; start a new game
    :HELP enter-help  ; help info within start menu
    :CREDS enter-creds  ; credits screen

    :states {}
    :current :HOME
    :_current nil

    :init init
    :draw draw
    :keypressed keypressed
    :update update
    :switch switch
})

instance
