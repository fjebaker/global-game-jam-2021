
; FUNCTION DEFINITIONS

(fn move [cret dt]
    (set cret.x (+ cret.x (* dt cret.velx)))
    (set cret.y (+ cret.y (* dt cret.vely)))
)

(fn getranddir []
    ; returns normalized random direction vector
    (let [theta (/ (math.random 0 360) (* 2 math.pi))]
        [
            ; xvel
            (math.sin theta)
            ; yvel
            (math.cos theta)
        ]
    )
)

; CONSTRUCTOR

(fn new [creeptype x y]
    (let [
            Mod (require (.. "src.creeps." creeptype))
            instance {}
        ]
        (each [key default (pairs _G.Creature)]
            ; check if default override
            (if (. Mod.Creep key)
                (tset instance key (. Mod.Creep key))
                ; else
                (tset instance key default)
            )
        )

        (tset instance :x x)
        (tset instance :y y)
        
        instance
    )
)

; LOVE CALLBACKS

(fn update [self dt]
    (set self.integrator (+ self.integrator dt))
    (if (> self.integrator self.clock)
        ; update clock value
        (do 
            ; init clock with new value, reset integrator
            (set self.clock (/ (math.random self.MIN_CLOCK self.MAX_CLOCK) 1000))
            (set self.integrator 0)

            ; choose new direction
            (let [[velx vely] (getranddir)]
                (print "New Direction" velx vely)
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

(fn draw [self]
    (love.graphics.setColor 255 0 0 255)
    (love.graphics.rectangle "fill" self.x self.y 20 20)   
)

; INTERFACE

(global Creature {
    :x 100
    :y 100
    :velx 1
    :vely 1
    
    :health 0

    ; "CONSTS"
    :MAX_VEL 10
    :MAX_CLOCK 5000
    :MIN_CLOCK 500

    :clock 0
    :integrator 0

    :draw draw
    :update update

    :new new
})


; MODULE EXPORTS 


{:Creature Creature}