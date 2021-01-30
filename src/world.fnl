(local utils (require :src.utils))

(local screen-width (love.graphics.getPixelWidth))
(local screen-height (love.graphics.getPixelHeight))
(local half-width (/ screen-width 2))
(local half-height (/ screen-height 2))


(fn draw [self objects]
    (let [(ox oy) (unpack [(- self.x half-width) (- self.y half-height)])
          (lx ly) (unpack [(+ ox screen-width) (+ oy screen-height)])]
        (each [_ obj (ipairs objects)]
            (when (and (<= ox obj.x) (<= obj.x lx) (<= oy obj.y) (<= obj.y ly))
                (obj:draw ox oy)
            )
        )
    )
)

(fn move [self delta]
    "Move the world's origin by some delta"
    (let [(dx dy) (unpack delta)
          (lx ly) (unpack self.limits)
          (ox oy) (unpack [(- self.x half-width) (- self.y half-height)])
          ; The new position
          (nx ny) (unpack [(+ ox dx) (+ oy dy)])]
        (set self.x (+ half-width (math.min lx (math.max 0 nx))))
        (set self.y (+ half-height (math.min ly (math.max 0 ny))))
    )
)

(fn update [self dt]
)


; INTERFACE
(local World {
    :limits [4000 4000]
    :x 0
    :y 0

    :draw draw
    :update update
    :move move
})

; CONSTRUCTOR
(fn new [x y]
    (let [instance (utils.tcopy World)]
        (set instance.x x)
        (set instance.y y)
        instance
    )
)

; MODULE EXPORTS
{:new new}
