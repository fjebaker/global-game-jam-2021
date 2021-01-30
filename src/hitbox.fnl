(local utils (require :src.utils))

(fn pointin [self x y]
    ; specific geometry implemented here

    ; circles only for now
    (< (math.sqrt (+ (* x x) (* y y))) self.radius)
)


(local HitBox {
    :radius 0        ; used as a far-field estimate for collisions
                     ; and for whether to use a finer calculation
    
    :pointin pointin ; whether point x, y is within the hitbox
})

(fn new [radius]
    (let [instance (utils.tcopy HitBox)]
        (set instance.radius radius)
        instance
    )
)

{:new new}