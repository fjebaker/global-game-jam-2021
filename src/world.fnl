(local utils (require :src.utils))

(local screen-width (love.graphics.getPixelWidth))
(local screen-height (love.graphics.getPixelHeight))
(local half-width (/ screen-width 2))
(local half-height (/ screen-height 2))

; METHODS

(fn boundary [self]
    (let [(lx ly) (unpack self.limits)]
        (values 0 0 lx ly)
    )
)

(fn draw [self objects]
    "Draw a collection of objects"
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

(fn drawmap [self]
    "Draw the background"
    (love.graphics.draw self.floormesh (- half-width self.x) (- half-height self.y))
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

(fn position [self]
    (values self.x self.y)
)

(fn update [self dt]
    (self.physics:update dt)
)

; PRIVATE UTILS

(fn collision-start-cb [f1 f2 contact]
    (let [o1 (f1:getUserData)
          o2 (f2:getUserData)]
        (when (and o1 o2)
            (o1:collide-with o2 contact)
        )
    )
)

(fn collision-end-cb [f1 f2 contact]
    (let [o1 (f1:getUserData)
          o2 (f2:getUserData)]
        (when (and o1 o2)
            (o1:part-with o2 contact)
        )
    )
)


(fn create-walls [instance]
    "Add static walls to the world to keep things in bounds"
    (let [(lx ly) (unpack instance.limits)
          mx (/ lx 2)
          my (/ ly 2)
          walls [
              [-1 my 2 ly]
              [mx -1 lx 2]
              [(+ 1 lx) my 2 ly]
              [mx (+ 1 ly) lx 2]]]
        (each [_ wall (ipairs walls)]
            (let [(x y w h) (unpack wall)
                  body (love.physics.newBody instance.physics x y :static)
                  shape (love.physics.newRectangleShape w h)]
                (love.physics.newFixture body shape)
            )
        )
    )
)

(fn newfloortexture [instance coords]
    (let [
            mesh (love.graphics.newMesh coords)
            graphic (love.graphics.newImage instance.floor-texture)
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

; INTERFACE
(local World {
    :limits [4000 4000]
    :x 0
    :y 0

    ; PHYSICS SIM
    :physics nil

    ; METHODS
    :boundary boundary
    :draw draw
    :drawmap drawmap
    :move move
    :position position
    :update update

    ; MAP IMAGES
    :floor-texture "assets/floortile.png"
    :wall-texture ""
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
        (instance.physics:setCallbacks collision-start-cb collision-end-cb)
        (create-walls instance)

        instance
    )
)

; MODULE EXPORTS
{
    :new new
}
