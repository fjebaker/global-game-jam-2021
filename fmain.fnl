(local utils (require :src.utils))
(local pm (require :src.pause_menu))

; State
(var world nil)
(var objects [])
(var state (require :src.state))


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
                Hero (require :src.hero)
                tbl []
            ]
            (tset tbl 1 (Hero.new 2000 2000 world))
            (for [i 1 10]
                (tset tbl (+ 1 (length tbl))
                    (Creature.new :ant (+ 1800 (* i 50)) (+ 1800 (* i 50)) world.physics))
            )
            tbl
        )
    )
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
            (pm:draw)
        )
    )
)

(fn love.update [dt]

    ;check state then check inputs
    
    (if
        ; Game state
        (= state.current "IN-GAME")
        (do
            ; do input
            (when (love.keyboard.isDown "down")
                (world:move [0 5])
            )
            (when (love.keyboard.isDown "up")
                (world:move [0 -5])
            )
            (when (love.keyboard.isDown "right")
                (world:move [5 0])
            )
            (when (love.keyboard.isDown "left")
                (world:move [-5 0])
            )
            (when (love.keyboard.isDown "escape")
                (set state.current "PAUSE")
            )
        )
        ; Paused state
        (= state.current "PAUSE")
        (do
            (pm:update)
            (when (love.keyboard.isDown "escape")
                (set state.current "IN-GAME")
            )
        )    
    )

    ; update
    (world:update dt)
    (utils.tmapupdate objects dt)
)