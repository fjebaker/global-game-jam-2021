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
    :edible true
    :draggable true

    ; ATTRIBUTES
    :amount max-food ; used as maximum amount
    :fclass 0 ; food class

})

(fn new [foodtype x y physicsworld]
    (let [
            Food (require (.. "src.foods." foodtype))
            attributes {}
            instance {}
        ]
        (utils.tadd attributes FoodObject)
        (utils.tadd attributes Food)
        (Entity.new instance attributes x y physicsworld :dynamic)

        ; calculate initial tinting
        (updatetint instance)

        ; Attach an instance reference to the fixture for collision reporting
        (instance.fixture:setUserData instance)

        instance
    )

)

{:new new :eat eat}