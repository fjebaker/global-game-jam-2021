
; IMPORTS
(local utils (require :src.utils))
(local Entity (require :src.entity))

; CONSTANTS
(local half-pi (/ math.pi 2))
(local movements {
    :right [0.5 0.0 half-pi]
    :down [0.0 0.5 math.pi]
    :left [-0.5 0.0 (+ math.pi half-pi)]
    :up [0.0 -0.5 0.0]
})

; METHODS

(fn update [self dt]
    (each [key delta (pairs movements)]
        (when (love.keyboard.isDown key)
            (let [(dx dy angle) (unpack delta)]
                (self.body:applyLinearImpulse dx dy)
                ; Point in the direction of movement
                (self.body:setAngle angle)
            )
        )
    )
    ; Keep the world centered on us
    (let [(ox oy lx ly) (self._world:boundary)
          (wx wy) (self._world:position)
          (x y) (self:position)
          dx (- x wx)
          dy (- y wy)]
        (when (and (<= ox x) (<= x lx) (<= oy y) (<= y ly))
            (self._world:move [dx dy])
        )
    )
)

; INTERFACE

(local Hero {
    :_world nil

    ; PHYSICS QUANTS
    :mass 0.02
    :damping 2

    ; STATS
    :hunger 75

    ; IMAGE VALS
    :image "assets/beetle.png"
    :X_MID 137
    :Y_MID 150

    ; OVERRIDES
    :update update
})

; CONSTRUCTOR

(fn new [x y world]
    (let [instance {}]
        (Entity.new instance x y world.physics :dynamic)
        (utils.tadd instance Hero)

        (set instance._world world)

        ; Set up character physics
        (set instance.shape (love.physics.newRectangleShape 250 270))
        (set instance.fixture (love.physics.newFixture instance.body instance.shape))
        (instance.body:setMass instance.mass)
        (instance.body:setLinearDamping instance.damping)
        (instance.body:setAwake true)

        ; load image from path
        (utils.tloadimage instance 137 150)

        instance
    )
)


; MODULE EXPORTS
{:new new}
