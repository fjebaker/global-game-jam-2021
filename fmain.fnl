(local world (require :world))

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
