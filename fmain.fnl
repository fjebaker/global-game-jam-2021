(local audio (require :src.audio))
(local william (require :src.william))
(local state-machine (require :src.state))


; LÖVE Hooks
(fn love.load []
    ; Do this first!
    (state-machine:init)

    (let [font (love.graphics.newFont "assets/fonts/AgreementSignature-qZX6x.ttf" 40)]
        (love.graphics.setFont font)
    )

    (math.randomseed (os.time)) ; init random number seed

    (william.loadquotes)
    (william.playrandom)

    (audio.playsongloop)
)

(fn love.draw []
    (love.graphics.clear)
    (state-machine:draw)
)

(fn love.keypressed [key scancode isrepeat]
    (state-machine:keypressed key isrepeat)
)

(fn love.update [dt]
    ; update the state machine
    (state-machine:update dt)
    ; update william
    (william.update dt)
)
