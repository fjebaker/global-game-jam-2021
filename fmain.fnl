(local utils (require :src.utils))
(local audio (require :src.audio))

(local startmenu (require :src.start_menu))
(local pausemenu (require :src.pause_menu))

(local Kafkaesque (require :src.Kafkaesque))

; State
(var state (require :src.state))
(var game nil)

;SETTING FONT
(var font (love.graphics.newFont "assets/fonts/AgreementSignature-qZX6x.ttf" 40))
(love.graphics.setFont font)

; LÖVE Hooks
(fn love.load []
    (audio.playsongloop)
)

(fn love.draw []
    (love.graphics.clear)
    (if (= state.current "IN-GAME")
        ; draw game
        (game:draw)
    )
    (if (= state.current "PAUSE")
        (do
            (pausemenu:draw)
        )
    )
    (if (= state.current "HOME")
        (do
            (startmenu:draw)
        )
    )
)

(local clock {
    :integrator 0
    :delay 0.1 ; button delay

    :reset (fn reset [self] 
        (set self.integrator 0)
    )
    :expired (fn expired [self] 
        (> self.integrator self.delay)
    )
    :add (fn add [self dt] 
        (set self.integrator (+ self.integrator dt))
    )
})

(fn love.update [dt]
    (clock:add dt)
    ;check when to start game
    (if (= state.current "RESET")
        (do 
            (set game (Kafkaesque.newgame))
            (set state.current "IN-GAME")
        )
    )
    ;check state then check inputs
    (if
        ; Home screen
        (= state.current "HOME")
        (do
            (startmenu.update dt)
        )
        ; Paused state
        (= state.current "PAUSE")
        (do
            (pausemenu.update dt)
            (if (clock:expired)
                (when (love.keyboard.isDown "escape")
                    (clock:reset)
                    (set state.current "IN-GAME")
                )
            )
        )

        ; Game state
        (= state.current "IN-GAME")
        (do 
            ; update game
            (game:update dt)


            (when (love.keyboard.isDown "escape")
                (set state.current "PAUSE")

            )
        )

    )
)
