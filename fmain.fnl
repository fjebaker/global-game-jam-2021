(local utils (require :src.utils))
(local audio (require :src.audio))

; State
(var world nil)
(var objects [])


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
    (audio.playsongloop)
)

(fn love.draw []
    (love.graphics.clear)
    (world:drawmap)
    (world:draw objects)
)

(fn love.update [dt]
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

    ; update
    (world:update dt)
    (utils.tmapupdate objects dt)
)