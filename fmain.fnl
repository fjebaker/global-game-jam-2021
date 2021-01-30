(local utils (require :src.utils))
(local audio (require :src.audio))

(local startmenu (require :src.start_menu))
(local pausemenu (require :src.pause_menu))

; State
(var world nil)
(var objects [])
(var state (require :src.state))

;SETTING FONT
(var font (love.graphics.newFont "assets/fonts/AgreementSignature-qZX6x.ttf" 50))
(love.graphics.setFont font)

; LÖVE Hooks
(fn love.load []
    (set world
        (let [World (require :src.world)]
            (World.new 2000 2000)
        )
    )
    (set objects
        (let [
                Creature (require :src.creature)
                Food (require :src.food)
                Hero (require :src.hero)
                tbl []
            ]
            (tset tbl 1 (Hero.new 2000 2000 world))
            (for [i 1 10]
                (do
                    (tset tbl (+ 1 (length tbl))
                        (Creature.new :ant (+ 1800 (* i 50)) (+ 1800 (* i 50)) world.physics)
                    )

                    (tset tbl (+ 1 (length tbl))
                        (Food.new :flower (math.random 0 3900) (math.random 0 3900) world.physics)
                    )
                )
            )
            tbl
        )
    )
    (audio.playsongloop)
)

(fn love.draw []
    (love.graphics.clear)
    (if (= state.current "IN-GAME")
        (do
            (love.graphics.clear)
            (world:drawmap)
            (world:draw objects)
        )
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

(fn love.update [dt]
    ;check state then check inputs
    (if
        ; Home screen
        (= state.current "HOME")
        (do
            (startmenu.update dt)
            (when (love.keyboard.isDown "escape")
                (set state.current "IN-GAME")
            )
        )
        ; Paused state
        (= state.current "PAUSE")
        (do
            (pausemenu.update dt)
            (when (love.keyboard.isDown "escape")
                (set state.current "IN-GAME")
            )
        )
        ; Game state
        (= state.current "IN-GAME")
        (do
            (world:update dt)
            (utils.tmapupdate objects dt)
            (when (love.keyboard.isDown "escape")
                (set state.current "PAUSE")
            )
        )
    )
)
