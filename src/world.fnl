(local screen-width (love.graphics.getPixelWidth))
(local screen-height (love.graphics.getPixelHeight))


(fn draw [self objects]
    (let [(px py) (unpack self.pos)
          (lx ly) (unpack [(+ px screen-width) (+ py screen-height)])]
        (each [_ obj (ipairs objects)]
            (when (and (<= px obj.x) (<= obj.x lx) (<= py obj.y) (<= obj.y ly))
                (obj:draw px py)
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
    :pos [2000 2000]

    :draw draw
    :update update
    :move move
}
