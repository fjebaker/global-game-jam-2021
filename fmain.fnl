(local world (require :world))


(local objects
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

(fn love.load []
  (world:setobjects objects)
)


(fn love.draw []
  (love.graphics.clear)
  (world:draw)
)

(fn love.update [dt]
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
  (world:update dt)
)
