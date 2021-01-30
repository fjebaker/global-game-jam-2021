(local Entity (require :src.entity))
(local utils (require :src.utils))

(local FoodObject {

    ; ATTRIBUTES
    :amount 100 ; used as maximum amount
    :fclass 0 ; food class

    ;

})

(fn updatetint [self]
    (let [
        gradient (/ self.amount FoodObject.amount) ; calculate amount of tint
        ]
        (set self.btint gradient)
        (set self.gtint gradient)
        (set self.atint (math.max 0.7 gradient))
    )
)

(fn eat [self amount]
    ; eats amount from food and returns remaining
    (set self.amount (- self.amount amount))
    (self:updatetint)
    self.amount
)

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
        ; calculate initial tinting
        (updatetint instance)

        ; physics
        (set instance.shape (love.physics.newRectangleShape 100 100))
        (set instance.fixture (love.physics.newFixture instance.body instance.shape))
        (instance.body:setAwake true)

        instance
    )

)

{:new new :eat eat}