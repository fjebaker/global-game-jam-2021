
; IMPORTS
(local utils (require :src.utils))


; METHODS

(fn draw [self ox oy]
    "Draw the entity relative to the origin (ox, oy)"
    (let [
            (x y) (self.body:getPosition)
            rotation (self.body:getAngle)
        ]
        (love.graphics.draw
            self.image
            (- x ox) (- y oy)
            rotation
            1 1
            self.X_MID self.Y_MID
        )
    )
)

(fn position [self]
    (self.body:getPosition)
)

(fn update [self dt]
)

; INTERFACE

(local Entity {
    ; PHYSICS
    :body nil
    :shape nil
    :fixture nil

    ; IMAGE VALS
    :image "assets/beetle.png"
    :X_MID 0
    :Y_MID 0

    ; PROPERTIES
    :health 0
    :draggable false
    :edible false
    :attackable false

    :draw draw
    :position position
    :update update
})

; CONSTRUCTOR

(fn new [instance x y physicsworld bodytype]
    (utils.tadd instance Entity)
    ; load image from path
    (utils.tloadimage instance 50 50)

    ; Init the physics state for the entity
    (set instance.body (love.physics.newBody physicsworld x y bodytype))

    instance
)


; MODULE EXPORTS
{:new new}
