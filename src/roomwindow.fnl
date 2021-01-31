(local utils (require :src.utils))

; METHODS

(fn isinside [self x y]
    ; awful way of doing this 
    (var ret false)

    (let [(x_min x_max y_min y_max) (unpack self.boundingbox)]
        (when (and (>= x x_min) (<= x x_max) (>= y y_min) (<= y y_max))
            (print "YOU WIN")
            (set ret true)
        )

    )

    ret
)


(fn draw [self xhalf yhalf]
    (love.graphics.setColor 1 1 1 0.7)
    (let [
        xpos (+ xhalf self.x)
        ypos (+ yhalf self.y)
        ]
        (if self.vertical
            (do
                (love.graphics.rectangle :fill (- xpos self.HEIGHT) ypos self.HEIGHT self.WIDTH)
            )
            ; horizontal
            (do
                (love.graphics.rectangle :fill xpos (- ypos self.HEIGHT) self.WIDTH self.HEIGHT)
            )
        )
    
    )
)

; INTERFACE

(local RoomWindow {

    :x 0
    :y 0 
    :vertical false

    :boundingbox nil ; [xmin xmax ymin ymax]

    ; CONFIG

    :WIDTH 700
    :HEIGHT 200  

    :draw draw
    :isinside isinside ; returns true/false position inside the window area
})


; CONSTRUCTORS

(fn newboundingbox [instance]
    (let [
        ret []
        ]
        (if instance.vertical 
            (do ; vertical config
                (tset ret 1 (- instance.x instance.HEIGHT))
                (tset ret 2 instance.x)
                (tset ret 3 instance.y)
                (tset ret 4 (+ instance.y instance.WIDTH))
            
            )
            (do ; horizontal config
                (tset ret 1 instance.x)
                (tset ret 2 (+ instance.x instance.WIDTH))
                (tset ret 3 (- instance.y instance.HEIGHT))
                (tset ret 4 instance.y)
            )
        ) 
        ret    
    )
)

(fn randompos [limits]
    (let [
        scale (/ (math.random 0 100 ) 100)
        ret []
        (xlimit ylimit) (unpack limits)
        ]
        (if (= (math.random 0 1) 0)
            ; vertical wall
            (do 
                (tset ret 1 (math.max (* (math.random 0 1) xlimit) RoomWindow.HEIGHT))
                (tset ret 2 (math.max (math.min (* scale ylimit) (- ylimit RoomWindow.WIDTH) ) RoomWindow.WIDTH)) ; clamped
                (tset ret 3 true)
            )
            ; horizontal wall 
            (do 
                (tset ret 1 (math.max (math.min (* scale xlimit) (- xlimit RoomWindow.WIDTH) ) RoomWindow.WIDTH) )
                (tset ret 2 (math.max (* (math.random 0 1) ylimit) RoomWindow.HEIGHT))
                (tset ret 3 false)
            )
        )   
        ret
    )

)

(fn new [world]
    (let [
        instance {}
        (x y vert) (unpack (randompos world.limits))
        ]
        (utils.tadd instance RoomWindow)
        (set instance.x x)
        (set instance.y y)
        (set instance.vertical vert)
        (set instance.boundingbox (newboundingbox instance))
        instance
    )

)

{
   :new new
}