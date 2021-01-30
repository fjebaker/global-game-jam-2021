(local world (require :src.world))
(local collisions (require :src.collisions))
(local utils (require :src.utils))
(local geo (require :src.geometry))

(local creatures
    (let [tbl []
          Creature (require :src.creature)]
        (for [i 1 10]
            (tset tbl i (Creature.new :ant (+ 2100 (* i 50)) (+ 2100 (* i 50))))
        )
        tbl
    )
)

(local objects
    (let [Entity (require :src.entity)]
        [(Entity.new :heart 2500 2500)]
    )
)


(fn love.load []
)


(fn love.draw []
    (love.graphics.clear)
    (world:draw creatures)
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


    ; do collisions
    (collisions.checkcollisions nil creatures objects)


    ; update
    (world:update dt)
    (utils.tmapupdate creatures dt)
    (utils.tmapupdate objects dt)
)
