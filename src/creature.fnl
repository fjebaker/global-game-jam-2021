
; IMPORTS
(local utils (require :src.utils))
(local Entity (require :src.entity))
(local geo (require :src.geometry))

; METHODS

(fn move [cret dt]
    (set cret.x (+ cret.x (* dt cret.velx)))
    (set cret.y (+ cret.y (* dt cret.vely)))
)

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
                (set self.rotation  (- (+ theta math.pi)))
                (set self.velx (* self.MAX_VEL velx))
                (set self.vely (* self.MAX_VEL vely))
            )
        )
        ; else
        (do
            (move self dt)
        )
    )
)

(fn collide [self object]
    ; collision logic here doesn't work well for non circular shapes
    ; either dispatch a different method, or TODO
    (let [
        dx (- self.x object.x)
        dy (- self.y object.y)
        (cx cy) (unpack (geo.normalize dx dy)) ; normed collision vector
        (vx vy) (unpack (geo.normalize self.velx self.vely)) ; normed velocity vector

        mag (- (/ (geo.dot cx cy vx vy) 2) 0.5) ; resultant collision effect
        ]
        ; (print dx dy)
        ; (print self " :: mag " mag)
        (set self.velx (* self.velx mag))
        (set self.vely (* self.vely mag))
    )
)

; INTERFACE

(local Creature {

    ; MOVEMENT
    :velx 0
    :vely 0
    :clock 0
    :integrator 0

    :MAX_VEL 10
    :MAX_CLOCK 5000
    :MIN_CLOCK 500

    ; PROPERTY UPDATES
    :health 100
    :collidable true
    :attackable true

    ; OVERRIDES
    :update update
    :collide collide

})


; CONSTRUCTOR

(fn new [creeptype x y]
    (let [
            Creep (require (.. "src.creeps." creeptype))
            instance (utils.tcopy Entity.Entity)
        ]
        (utils.tadd instance Creature)
        (utils.tmerge instance Creep)

        ; load image from path
        (utils.tloadimage instance 110 125)

        (set instance.x x)
        (set instance.y y)

        instance
    )
)

; MODULE EXPORTS

{:new new}