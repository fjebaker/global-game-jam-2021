
(fn dot [x1 y1 x2 y2]
    ; computes dot product
    (+ (* x1 x2) (* y1 y2))
)


(fn l1dist [x y]
    ; compute manhattan distance
    (+ x y)
)

(fn l2dist [x y]
    ; compute l2 distance
    (math.sqrt (dot x y x y))
)

(fn normalize [x y]
    ; normalizes the vector [x, y]
    (let [magnitude (l2dist x y)]
        [
            (/ x magnitude) 
            (/ y magnitude)
        ]
    )
)

{
    :l1dist l1dist
    :l2dist l2dist 
    :normalize normalize
    :dot dot 
}