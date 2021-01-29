(local screen-width (love.graphics.getPixelWidth))
(local screen-height (love.graphics.getPixelHeight))

(fn hsv [h s v]
  (let [(hp c) (unpack [(* h 6) (* s v)])
        (x) (* c (- 1 (math.abs (- (% hp 2) 1))))]
    (if
      (and (<= 0.0 hp) (<= hp 1.0)) [c x 0.0]
      (and (<= 1.0 hp) (<= hp 2.0)) [x c 0.0]
      (and (<= 2.0 hp) (<= hp 3.0)) [0.0 c x]
      (and (<= 3.0 hp) (<= hp 4.0)) [0.0 x c]
      (and (<= 4.0 hp) (<= hp 5.0)) [x 0.0 c]
      (and (<= 5.0 hp) (<= hp 6.0)) [c 0.0 x]
      [0.0 0.0 0.0]
    )
  )
)

;; For now, a rainbow grid
(local objects
  (let [tbl []]
    (for [y 10 4000 100]
      (for [x 10 4000 100]
        (tset tbl (+ (length tbl) 1) [x y (hsv (/ y 4000.0) (/ x 4000) 1.0)])))
    tbl
  )
)


(fn draw [self]
  (let [(px py) (unpack self.pos)
        (lx ly) (unpack [(+ px screen-width) (+ py screen-height)])]
    (each [_ pt (ipairs objects)]
      (let [[x y col] pt]
        (when (and (<= px x) (<= x lx) (<= py y) (<= y ly))
          (love.graphics.setColor (unpack col))
          (love.graphics.rectangle "fill" (- (- x px) 5) (- (- y py) 5) 10 10)
        )
      )
    )
  )
)

(fn update [self dt]
)

(fn move [self delta]
  "Move the world's origin by some delta"
  (let [(px py) (unpack self.pos)
        (lx ly) (unpack self.limits)
        (dx dy) (unpack delta)
        ; The new position
        (nx ny) (unpack [(+ px dx) (+ py dy)])]
    (set self.pos [(math.min lx (math.max 0 nx))
                   (math.min ly (math.max 0 ny))]
    )
  )
)

;; This is our world object
{
    :limits [4000 4000]
    :pos [0 0]
    :draw draw
    :update update
    :move move
}
