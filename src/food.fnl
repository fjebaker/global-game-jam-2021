(local Entity (require :src.entity))
(local utils (require :src.utils))

(local max-food 100)

(fn updatetint [self]
    (let [
        gradient (/ self.amount max-food) ; calculate amount of tint
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

(local FoodObject {

    ; PROPERTIES
    :draggable true

    ; PHYSICS QUANTS
    :mass 0.2
    :damping 0.5

    ; ATTRIBUTES
    :amount max-food ; used as maximum amount
    :fclass 0 ; food class

})

(fn new [foodtype x y physicsworld]
    (let [
            Food (require (.. "src.foods." foodtype))
            instance {}
        ]
        (Entity.new instance x y physicsworld :dynamic)
        (utils.tadd instance FoodObject)
        (utils.tmerge instance Food)
        ; image
        (utils.tloadimage instance 100 100)
        ; calculate initial tinting
        (updatetint instance)

        ; physics
        (set instance.shape (love.physics.newRectangleShape 100 100))
        (set instance.fixture (love.physics.newFixture instance.body instance.shape))
        (instance.body:setMass instance.mass)
        (instance.body:setLinearDamping instance.damping)
        (instance.body:setAwake true)
        ; Attach an instance reference to the fixture for collision reporting
        (instance.fixture:setUserData instance)

        instance
    )

)

{:new new :eat eat}