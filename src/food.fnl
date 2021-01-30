(local Entity (require :src.entity))
(local utils (require :src.utils))

(local FoodObject {

    ; ATTRIBUTES
    :amount 10
    :fclass 0 ; food class

})


(fn new [foodtype x y physicsworld]
    (let [
            Food (require (.. "src.foods." foodtype))
            instance {}
        ]
        (Entity.new instance x y physicsworld :static)
        (utils.tadd instance Food)
        (utils.tmerge instance Food)
        ; image
        (utils.tloadimage instance 100 100)
        ; physics
        (set instance.shape (love.physics.newRectangleShape 100 100))
        (set instance.fixture (love.physics.newFixture instance.body instance.shape))
        (instance.body:setAwake true)

        instance
    )

)

{:new new}