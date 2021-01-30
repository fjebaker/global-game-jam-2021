(local world (require :world))
(local collisions (require :src.collisions))
(local utils (require :src.utils))

(local creatures 
  (let [
      tbl []
      Creature (require :src.creature)
      ]
    (for [i 1 10]
      (tset tbl i (Creature.new :ant 500 500))
    )
    tbl
  )
)

(local objects 
  (let [WorldObj (require :src.worldobject)]
    [(WorldObj.new :heart 500 500)]
  )  
)


(fn love.load []

)


(fn love.draw []
  (love.graphics.clear)
  (world:draw creatures)
)

(fn love.update [dt]

  ; do input
  (when (love.keyboard.isDown "down")
    (world:move [0 5])
  )
  (when (love.keyboard.isDown "up")
    (world:move [0 -5])
  )
  (when (love.keyboard.isDown "right")
    (world:move [5 0])
  )
  (when (love.keyboard.isDown "left")
    (world:move [-5 0])
  )


  ; do collisions



  ; update
  (world:update dt)
  (utils.tmapupdate creatures dt)
)
