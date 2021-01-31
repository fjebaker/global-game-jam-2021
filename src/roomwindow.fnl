
(local utils (require :src.utils))

; METHODS

(fn positionin [x y]

)


(fn draw [self xhalf yhalf]
    (love.graphics.setColor 1 1 1 0.7)
    (let [
        xpos (+ xhalf self.x)
        ypos (+ yhalf self.y)
        ]
        (if self.vertical
            (do
                (love.graphics.rectangle :fill (- xpos self.HEIGHT) (- ypos self.WIDTH) self.HEIGHT self.WIDTH)
            )
            ; horizontal
            (do
                (love.graphics.rectangle :fill (- xpos self.WIDTH) (- ypos self.HEIGHT) self.WIDTH self.HEIGHT)
            )
        )
    
    )
)

; INTERFACE

(local RoomWindow {

    :x 0
    :y 0 
    :vertical false

    ; CONFIG

    :WIDTH 700
    :HEIGHT 50  



    :draw draw
    :positionin positionin ; returns true/false position inside the window area
})


; CONSTRUCTORS

(fn randompos [limits]
    (let [
        scale (/ (math.random 0 100 ) 100)
        ret []
        (xlimit ylimit) (unpack limits)
        ]
        (if (= (math.random 0 1) 0)
            ; vertical wall
            (do 
                (tset ret 1 (* (math.random 0 1) xlimit))
                (tset ret 2 (math.min (* scale ylimit) (- ylimit RoomWindow.WIDTH) )) ; clamped
                (tset ret 3 true)
            )
            ; horizontal wall 
            (do 
                (tset ret 1 (math.min (* scale xlimit) (- xlimit RoomWindow.WIDTH) ))
                (tset ret 2 (* (math.random 0 1) ylimit))
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
        instance
    )

)

{
   :new new
}