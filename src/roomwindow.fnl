(local utils (require :src.utils))

(local window-height 200)
(local window-width 400)

; METHODS

(fn draw [self ox oy]
    (love.graphics.setColor 1 1 1 0.7)
    (let [(x y) (self.body:getPosition)
          angle (self.body:getAngle)]
        (love.graphics.draw
            self.image
            (- x ox) (- y oy)
            angle
            1 1
            self.X_MID self.Y_MID
        )
    )
    ; Physics debugging
    ; (let [pts [(self.body:getWorldPoints (self.shape:getPoints))]
    ;       offpts []]
    ;     (for [i 1 (length pts) 2]
    ;         (do
    ;             (tset offpts i (- (. pts i) ox))
    ;             (tset offpts (+ i 1) (- (. pts (+ i 1)) oy))
    ;         )
    ;     )
    ;     (love.graphics.polygon :line (unpack offpts))
    ; )
)

(fn randompos [limits]
    (let [scale (/ (math.random 0 100 ) 100)
          (xlimit ylimit) (unpack limits)
          top-bottom-left-right (math.random 1 4)]
        (if (= top-bottom-left-right 1)
            ; top
            (values
                (math.max (math.min (* scale xlimit) (- xlimit window-width) ) window-width)
                0
                0
            )
            (= top-bottom-left-right 2)
            ; bottom
            (values
                (math.max (math.min (* scale xlimit) (- xlimit window-width) ) window-width)
                ylimit
                math.pi
            )
            (= top-bottom-left-right 3)
            ; left
            (values
                0
                (math.max (math.min (* scale ylimit) (- ylimit window-width) ) window-width)
                (* math.pi 1.5)
            )
            (= top-bottom-left-right 4)
            ; right
            (values
                xlimit
                (math.max (math.min (* scale ylimit) (- ylimit window-width) ) window-width)
                (* math.pi 0.5)
            )
        )
    )
)

(fn collide-with [self other contact]
    (set self.inwindow true)
)

(fn part-with [self other contact]
    (set self.inwindow false)
)

; INTERFACE

(local RoomWindow {

    ; IMAGE VALS
    :image "assets/window.png"
    :X_MID 0
    :Y_MID 0

    ; PHYSICS BITS
    :body nil
    :shape nil
    :fixture nil

    ; COLLISION attributes
    :edible false
    :collide-with collide-with
    :part-with part-with
    :inwindow false

    :draw draw
})

(fn new [world]
    (let [physicsworld (. world :physics)
          (x y angle) (randompos world.limits)
          instance {}]
        (utils.tadd instance RoomWindow)

        ; load the art
        (utils.tloadimage instance)

        (set instance.body (love.physics.newBody physicsworld x y :static))
        (set instance.shape (love.physics.newRectangleShape window-width window-height))
        (set instance.fixture (love.physics.newFixture instance.body instance.shape))
        (instance.body:setAngle angle)

        ; We only want collision callbacks
        (instance.fixture:setSensor true)
        ; Attach an instance reference to the fixture for collision reporting
        (instance.fixture:setUserData instance)

        instance
    )

)

{:new new}
