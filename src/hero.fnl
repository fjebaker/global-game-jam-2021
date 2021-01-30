
; IMPORTS
(local utils (require :src.utils))
(local Entity (require :src.entity))


; METHODS

(fn update [self dt]
)

; INTERFACE

(local Hero {
    ; IMAGE VALS
    :image "assets/beetle.png"
    :X_MID 50
    :Y_MID 50

    ; OVERRIDES
    :update update
})

; CONSTRUCTOR

(fn new [x y world]
    (let [instance {}]
        (Entity.new instance x y world.physics :static)
        (utils.tadd instance Hero)

        ; Set up character physics
        (set instance.shape (love.physics.newRectangleShape 100 100))
        (set instance.fixture (love.physics.newFixture instance.body instance.shape))

        ; load image from path
        (utils.tloadimage instance 50 50)

        instance
    )
)


; MODULE EXPORTS
{:new new}
