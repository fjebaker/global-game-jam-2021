
; LOCAL CONFIGURATION

(local MAX_CLOCK 5000)
(local MIN_CLOCK 500)

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

(fn new [creturetype x y]
    (print "NEW")
    (let [instance {}]
        (each [key default (pairs _G.Creature)]
            (tset instance key default)
        )
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
            (set self.clock (/ (math.random MIN_CLOCK MAX_CLOCK) 1000))
            (set self.integrator 0)

            ; choose new direction
            (let [[velx vely] (getranddir)]
                (print "New Direction" velx vely)
                (set self.velx (* self.maxvel velx))
                (set self.vely (* self.maxvel vely))
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
    :maxvel 10

    :clock 0
    :integrator 0

    :draw draw
    :update update

    :new new
})


; MODULE EXPORTS 


{:Creature Creature}