
; IMPORTS 
(local utils (require :src.utils))
(local WorldObject (require :src.worldobject))

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

    ; OVERRIDES 
    :update update
    :collide collide

})


; CONSTRUCTOR

(fn new [creeptype x y]
    (let [
            Creep (require (.. "src.creeps." creeptype))
            instance (utils.tcopy WorldObject.WorldObject)
        ]
        (utils.tadd instance Creature)
        (utils.tmerge instance Creep)

        ; load image from path
        (utils.tloadimage instance 30 45)

        (set instance.x x)
        (set instance.y y)

        instance
    )
)

; MODULE EXPORTS 

{:new new} 