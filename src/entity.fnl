
; IMPORTS
(local utils (require :src.utils))

; METHODS

(fn draw [self ox oy]
    "Draw the entity relative to the origin (ox, oy)"
    (let [
            (x y) (self.body:getPosition)
            rotation (self.body:getAngle)
        ]
        (love.graphics.setColor self.rtint self.gtint self.btint self.atint) ; set custom tint
        (love.graphics.draw
            self.image
            (- x ox) (- y oy)
            rotation
            1 1
            self.X_MID self.Y_MID
        )
        (love.graphics.setColor 1 1 1 1) ; unset colour
        ; Physics bounding box debugging
        ; (let [pts [(self.body:getWorldPoints (self.shape:getPoints))]
        ;       offpts []]
        ;     (for [i 1 (length pts) 2]
        ;         (do
        ;             (tset offpts i (- (. pts i) ox))
        ;             (tset offpts (+ i 1) (- (. pts (+ i 1)) oy))
        ;         )
        ;     )
        ;     (love.graphics.polygon "line" (unpack offpts))
        ; )
    )
)

(fn position [self]
    (self.body:getPosition)
)

(fn update [self dt]
)

(fn collide-with [self other contact]
)

(fn part-with [self other contact]
)

; INTERFACE

(local Entity {
    ; PHYSICS
    :body nil
    :shape nil
    :fixture nil

    ; PHYSICS QUANTS
    :mass 0
    :damping 1
    :bbox [0 0]

    ; TINTING
    :rtint 1
    :gtint 1
    :btint 1
    :atint 1

    ; IMAGE VALS
    :image ""
    :X_MID 0
    :Y_MID 0

    ; PROPERTIES
    :health 0
    :draggable false
    :edible false
    :attackable false

    :collide-with collide-with
    :part-with part-with
    :draw draw
    :position position
    :update update
})

; CONSTRUCTOR

(fn new [instance extras x y physicsworld bodytype]
    (utils.tadd instance Entity)
    (utils.tadd instance extras)

    ; load image from path
    (utils.tloadimage instance)

    ; Init the physics state for the entity
    (set instance.body (love.physics.newBody physicsworld x y bodytype))
    (set instance.shape (love.physics.newRectangleShape (unpack instance.bbox)))
    (set instance.fixture (love.physics.newFixture instance.body instance.shape))
    (instance.body:setMass instance.mass)
    (instance.body:setLinearDamping instance.damping)
    (instance.body:setAwake true)

    instance
)


; MODULE EXPORTS
{:new new}
