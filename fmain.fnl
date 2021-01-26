(local canvas (let [(w h) (love.window.getMode)] (love.graphics.newCanvas w h)))

(fn love.draw []
  (love.graphics.setCanvas canvas)
  (love.graphics.clear)
  (love.graphics.setCanvas)
)
