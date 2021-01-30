(local utils (require :src.utils))

(local screen-width (love.graphics.getPixelWidth))
(local screen-height (love.graphics.getPixelHeight))
(local half-width (/ screen-width 2))
(local half-height (/ screen-height 2))

(fn newfloortexture [instance coords]
    (let [
        mesh (love.graphics.newMesh coords)
        graphic (love.graphics.newImage instance.floor_texture)
    ]
        (graphic:setWrap :repeat :repeat)
        (mesh:setTexture graphic)

        (tset instance :floormesh mesh)
    )
)

(fn newmap [instance]
    ; calculate new map vertices
    (let [
        mapcoords []
        (width height) (unpack instance.limits)
        s (. instance :floor-texture-scale)
        RoomWindow (require :src.roomwindow)
        ]
        (table.insert mapcoords [0 0            0 0])
        (table.insert mapcoords [width 0        s 0])
        (table.insert mapcoords [width height   s s])
        (table.insert mapcoords [0 height       0 s])

        ; assign textures to instance
        (newfloortexture instance mapcoords)

        ; init a window
    )
)

(fn drawmap [self]
    (love.graphics.draw self.floormesh (- screen-width self.x) (- screen-height self.y))
)

; RENDERING

(fn draw [self objects]
    (let [(ox oy) (unpack [(- self.x half-width) (- self.y half-height)])
          (lx ly) (unpack [(+ ox screen-width) (+ oy screen-height)])]
        (each [_ obj (ipairs objects)]
            (let [(x y) (obj:position)]
                (when (and (<= ox (+ x 100)) (<= (- x 100) lx) (<= oy (+ y 100)) (<= (- y 100) ly))
                    (obj:draw ox oy)
                )
            )
        )
    )
)


(fn update [self dt]
    (self.physics:update dt)
)


; MOTION


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

; INTERFACE
(local World {
    :limits [4000 4000]
    :x 0
    :y 0

    :physics nil

    :draw draw
    :drawmap drawmap
    :update update
    :move move

    ; MAP IMAGES
    :floor_texture "assets/floortile.png"
    :wall_texture ""
    :floor-texture-scale 20
    :wall-texture-scale 1

    ; MESHES
    :floormesh nil
    :wallmesh nil
})

; CONSTRUCTOR
(fn new [x y]
    (let [instance (utils.tcopy World)]
        ; Meshing and map
        (newmap instance)
        ; World position
        (set instance.x x)
        (set instance.y y)
        ; New physics world with no gravity and sleepable bodies
        (set instance.physics (love.physics.newWorld 0 0 true))
        instance
    )
)

; MODULE EXPORTS
{:new new}
