
; IMPORTS
(local utils (require :src.utils))
(local Entity (require :src.entity))

; METHODS

(fn getranddir []
    ; returns normalized random direction vector
    (let [theta (* (/ (math.random 0 360) 360) (* 2 math.pi))]
        [
            theta
            ; xvel
            (math.sin theta)
            ; yvel
            (math.cos theta)
        ]
    )
)

(fn update [self dt]
    (set self.integrator (+ self.integrator dt))
    (if (> self.integrator self.clock)
        ; update clock value
        (do
            ; init clock with new value, reset integrator
            (set self.clock (/ (math.random self.MIN_CLOCK self.MAX_CLOCK) 1000))
            (set self.integrator 0)

            ; choose new direction
            (let [[theta velx vely] (getranddir)]
                (self.body:setLinearVelocity (* self.MAX_VEL velx) (* self.MAX_VEL vely))
                (self.body:setAngle (- (+ theta math.pi)))
            )
        )
        ; else
    )
)

; INTERFACE

(local Creature {
    ; MOVEMENT
    :clock 0
    :integrator 0

    :MAX_VEL 10
    :MAX_CLOCK 5000
    :MIN_CLOCK 500

    ; PROPERTY UPDATES
    :health 100
    :attackable true

    ; OVERRIDES
    :update update
})


; CONSTRUCTOR

(fn new [creeptype x y physicsworld]
    (let [
            Creep (require (.. "src.creeps." creeptype))
            attributes {}
            instance {}
        ]
        (utils.tadd attributes Creature)
        (utils.tadd attributes Creep)
        (Entity.new instance attributes x y physicsworld :dynamic)

        instance
    )
)

; MODULE EXPORTS

{:new new}