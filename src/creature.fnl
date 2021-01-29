
; FUNCTION DEFINITIONS

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

        ; load image from path
        (set instance.image (love.graphics.newImage instance.image))
        (let [
            width (love.graphics.getPixelWidth instance.image)
            height (love.graphics.getPixelHeight instance.image)
            ]
            (set instance.X_MID 30)
            (set instance.Y_MID 45)
        )

        (set instance.x x)
        (set instance.y y)

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

(fn draw [self]
    (love.graphics.setColor 255 0 0 255)

    (love.graphics.draw 
        self.image 
        self.x self.y 
        self.rotation
        1 1 
        self.X_MID self.Y_MID
    )   
)

; INTERFACE

(global Creature {
    :x 100
    :y 100
    :velx 0
    :vely 0
    :rotation 0
    :health 100

    ; "CONSTS"
    :MAX_VEL 10
    :MAX_CLOCK 5000
    :MIN_CLOCK 500

    ; IMAGE VALS
    :image ""
    :X_MID 0
    :Y_MID 0

    :clock 0
    :integrator 0

    :draw draw
    :update update

    :new new
})


; MODULE EXPORTS 


{:Creature Creature}