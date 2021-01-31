
; IMPORTS
(local utils (require :src.utils))
(local Entity (require :src.entity))
(local EatHitBox (require :src.actions.eat))

; CONSTANTS
(local half-pi (/ math.pi 2))
(local movements {
    :right [0.5 0.0 half-pi]
    :down [0.0 0.5 math.pi]
    :left [-0.5 0.0 (+ math.pi half-pi)]
    :up [0.0 -0.5 0.0]
    :d [0.5 0.0 half-pi]
    :s [0.0 0.5 math.pi]
    :a [-0.5 0.0 (+ math.pi half-pi)]
    :w [0.0 -0.5 0.0]
})


; ACTION CLOCK
(local clock {
    :integrator 0
    :delay 0.5 ; button delay

    :reset (fn reset [self] 
        (set self.integrator 0)
    )
    :expired (fn expired [self] 
        (> self.integrator self.delay)
    )
    :add (fn add [self dt] 
        (set self.integrator (+ self.integrator dt))
    )
})

; METHODS
(fn eat [self]
    (var x 0) (var y 0)
    (lua "x, y = self.body:getPosition()") ; only way i can get both????
    (self.eathitbox:spawn x y)
)

(fn update [self dt]
    ; Handle movement
    (each [key delta (pairs movements)]
        (when (love.keyboard.isDown key)
            (let [(dx dy angle) (unpack delta)]
                (self.body:applyLinearImpulse dx dy)
                ; Point in the direction of movement
                (self.body:setAngle angle)
            )
        )
    )

    (clock:add dt)
    (if (clock:expired)
        (if (not self.acting)
            (if (love.keyboard.isDown :space)
                (do
                    (self:eat)
                    (clock:reset)
                    (set self.acting true)
                )
            )
            (do (set self.acting false) (self.eathitbox:despawn))
        )
    )


    ; Keep the world centered on us
    (let [(ox oy lx ly) (self._world:boundary)
          (wx wy) (self._world:position)
          (x y) (self:position)
          dx (- x wx)
          dy (- y wy)]
        (when (and (<= ox x) (<= x lx) (<= oy y) (<= y ly))
            (self._world:move [dx dy])
        )
    )
)

(fn starving [self dt]
    ; applies starve mechanic and returns bool for less than 0
    (set self.hunger (- self.hunger (* self.S_RATE dt)))
    (< self.hunger 0)
)

(fn collide-with [self other contact]
)

(fn part-with [self other contact]
)

; INTERFACE

(local Hero {
    :_world nil

    ; PHYSICS QUANTS
    :mass 0.02
    :damping 2

    ; STATS
    :hunger 75

    ; ACTIONS 
    :eathitbox nil
    :acting false
    :eat eat

    ; STARVE MECHANICS
    :S_RATE 5   ; starve rate in amount per second
    :starving starving

    ; IMAGE VALS
    :image "assets/beetle.png"
    :X_MID 137
    :Y_MID 150

    ; OVERRIDES
    :update update
    :collide-with collide-with
    :part-with part-with
})

; CONSTRUCTOR

(fn new [x y world]
    (let [instance {}]
        (Entity.new instance x y world.physics :dynamic)
        (utils.tadd instance Hero)

        (set instance._world world)

        ; Set up character physics
        (set instance.shape (love.physics.newRectangleShape 250 270))
        (set instance.fixture (love.physics.newFixture instance.body instance.shape))
        (instance.body:setMass instance.mass)
        (instance.body:setLinearDamping instance.damping)
        (instance.body:setAwake true)
        ; Attach an instance reference to the fixture for collision reporting
        (instance.fixture:setUserData instance)

        ; load image from path
        (utils.tloadimage instance 137 150)
        (instance.fixture:setMask 2)
        
        ; configure eat hit box
        (set instance.eathitbox (EatHitBox.new instance world.physics))

        instance
    )
)


; MODULE EXPORTS
{:new new}
