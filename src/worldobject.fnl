; METHODS

(fn draw [self px py]
    ; (love.graphics.setColor 255 255 255 255)
    (love.graphics.draw 
        self.image 
        (- self.x px) (- self.y py)
        self.rotation
        1 1 
        self.X_MID self.Y_MID
    )   
)

(fn update [self dt]

)


; INTERFACE

(local WorldObject {
    :x 0
    :y 0
    :mass 0
    :rotation (/ math.pi 4) 

    ; IMAGE VALS
    :image "assets/heart.jpg"
    :X_MID
    :Y_MID


    :collide false
    :draggable false

    :draw draw
    :update update
})

; CONSTRUCTOR

(fn new [objtype x y]
    (let [ instance {} ]
        (each [key default (pairs WorldObject)]
            (tset instance key default)
        )   

        ; load image from path
        (set instance.image (love.graphics.newImage instance.image))
        (let [
            width (love.graphics.getPixelWidth instance.image)
            height (love.graphics.getPixelHeight instance.image)
            ]
            (set instance.X_MID 50) ; MAGIC VALUES :D 
            (set instance.Y_MID 50)
        )

        (set instance.x x)
        (set instance.y y)

        instance
    )
)


; MODULE EXPORTS 

{:new new}