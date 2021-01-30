
; There is so much optimisation that could be do here
; even from just simple things like precalculating the l2distances
; instead of theoretically having to compute it multiple times per loop
; but I am tired and this needs to get done so there.

(local geo (require :src.geometry))

(fn areclose [obj1 obj2]
    ; checks if l2 distance under radius
    (let [
        d1 (geo.l2dist obj1.x obj1.y)
        d2 (geo.l2dist obj2.x obj2.y)
    ]
        ; finer geometry calculations would go here if we need them
        (> obj1.hitbox.radius (math.abs (- d1 d2)))
    )
)

(fn collisions [arr1 arr2]
    ; collides arr1 with arr2
    (each [_ obj1 (ipairs arr1)]
        (if obj1.collidable ; short circuit check

            (each [_ obj2 (ipairs arr2)]
                (if (and obj2.collidable (not (= obj1 obj2)))
                    (if (areclose obj1 obj2)
                        (obj1:collide obj2)
                    )
                )
            )
            ; else skip
        )
    )
)


(fn checkcollisions [player creatures objects]
    ; check collisions between player and objects

    ; check collisions between player and creatures

    ; check collisions between creatures and creatures
    (collisions creatures creatures)

    ; check collisions between creatures and objects
)

{:checkcollisions checkcollisions}