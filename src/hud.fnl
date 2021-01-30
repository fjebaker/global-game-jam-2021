

(local HungerBar {

    :MAX_VALUE 100

    ; DIMENSIONS
    :width 200
    :height 20

    ; LOCATION ON SCREEN
    :x 10
    :y (- (love.graphics.getPixelHeight) 30 )

    ; CONFIG
    :colour [1 1 1 1]

})

(fn drawbox []
    (love.graphics.print "Hunger" HungerBar.x (- HungerBar.y 10 HungerBar.height))
    (love.graphics.rectangle :line HungerBar.x HungerBar.y HungerBar.width HungerBar.height)
    (love.graphics.rectangle :line HungerBar.x HungerBar.y HungerBar.width HungerBar.height)
)

(fn drawstatus [hero]
    (let [width (* (/ hero.hunger HungerBar.MAX_VALUE) HungerBar.width)]
        (love.graphics.setColor 1 0 0 1)
        (love.graphics.rectangle :fill HungerBar.x HungerBar.y width HungerBar.height)
        (love.graphics.setColor 1 1 1 1)
    )

)

(fn draw [hero]
    (drawstatus hero)
    (drawbox)
)

{
    :hunger HungerBar
    :draw draw
}