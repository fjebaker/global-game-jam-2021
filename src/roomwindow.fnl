(local utils (require :src.utils))

(local window-height 200)
(local window-width 700)

; METHODS

(fn draw [self ox oy]
    (love.graphics.setColor 1 1 1 0.7)
    (let [pts [(self.body:getWorldPoints (self.shape:getPoints))]
          offpts []]
        (for [i 1 (length pts) 2]
            (do
                (tset offpts i (- (. pts i) ox))
                (tset offpts (+ i 1) (- (. pts (+ i 1)) oy))
            )
        )
        (love.graphics.polygon :fill (unpack offpts))
    )
)

(fn randompos [limits]
    (let [scale (/ (math.random 0 100 ) 100)
          (xlimit ylimit) (unpack limits)]
        (if (< (math.random 0 10) 5)
            ; vertical wall
            (values
                (math.max (* (math.random 0 1) xlimit) window-height)
                (math.max (math.min (* scale ylimit) (- ylimit window-width) ) window-width)
                window-height
                window-width
            )
            ; horizontal wall
            (values
                (math.max (math.min (* scale xlimit) (- xlimit window-width) ) window-width)
                (math.max (* (math.random 0 1) ylimit) window-height)
                window-width
                window-height
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

    :body nil
    :shape nil
    :fixture nil

    ; COLLISION attributes
    :edible false
    :collide-with collide-with
    :part-with part-with
    :inwindow false

    ; CONFIG
    :WIDTH window-width
    :HEIGHT window-height

    :draw draw
})

(fn new [world]
    (let [physicsworld (. world :physics)
          (x y w h) (randompos world.limits)
          instance {}]
        (utils.tadd instance RoomWindow)

        (set instance.body (love.physics.newBody physicsworld x y :static))
        (set instance.shape (love.physics.newRectangleShape w h))
        (set instance.fixture (love.physics.newFixture instance.body instance.shape))

        ; We only want collision callbacks
        (instance.fixture:setSensor true)
        ; Attach an instance reference to the fixture for collision reporting
        (instance.fixture:setUserData instance)

        instance
    )

)

{:new new}
