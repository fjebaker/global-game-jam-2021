(var starting_pos [95 500])
(var pos starting_pos)
(var button_spacing 50)

; make empty table of buttons
(local buttons []) 

;function for adding to table
(fn addButton [text funct]
    (table.insert buttons [text funct]))

;make buttons
(fn git_function []
    (love.graphics.print "url" 100 50)
      (love.system.openURL "https://github.com/dustpancake/global-game-jam-2021")
)
(addButton "GitHub." git_function)

(fn fonts_function []
    (love.graphics.print "url" 100 50)
    (love.system.openURL "https://www.fontspace.com/a-agreement-signature-font-f52534")
    (love.system.openURL "https://www.fontspace.com/nugo-sans-font-f52173")
)
(addButton "Fonts." fonts_function)

(fn wiki_function []
    (love.graphics.print "url" 100 50)
      (love.system.openURL "https://en.wikipedia.org/wiki/The_Metamorphosis")
)

(addButton "Metamorphosis?" wiki_function)

(fn but_funct []
    (var state (require :src.state))
    (set state.current "HOME")
)
(addButton "Back to Menu - (enter)" but_funct)

;assign button positions

(let [[a0 b0] starting_pos]
    (for [i 1 (length buttons)]
        (let [button (. buttons i)]

            (var bx (+ b0 5))
            (var by ( + (* button_spacing (- i 1)) (+ b0 5)))
            (table.insert button bx)
            (table.insert button by)
        )
    )
)

(fn draw []

    (let [[a b] pos]
    
        (love.graphics.draw (love.graphics.newImage "assets/start_menu_bg.png") 0 0 0 0.7 0.7 0 0 0)

        (love.graphics.print "Kafkaesque - Credits." 100 50)

        ;CHANGING FONT FOR THIS PARA
        (var font (love.graphics.newFont "assets/fonts/NugoSansLight-9YzoK.ttf" 20))
        (love.graphics.setFont font)      

        (love.graphics.print "Authors:
dustpancake, jwiggins & shellywell123

We would like to thank the following people:

dustpancake & shellywell123 for the Art & Music 
William Lawson for the voice acting
Franz Kafka for the inspiration." 100 200)

        ;RESETTING FONT
        (var font (love.graphics.newFont "assets/fonts/AgreementSignature-qZX6x.ttf" 40))
        (love.graphics.setFont font)

        ;(love.graphics.rectangle "line" a b 150 button_spacing)

        (for [i 1 (length buttons)]
            (let [button (. buttons i)]

                (var text     (. button 1))
                (var function (. button 2))
                (var bx       (. button 3))
                (var by       (. button 4))

                (love.graphics.print text bx by)
                ;(love.graphics.print bx 200 200)
            )   

        )
    )
    
)

(local clock {
    :integrator 0
    :delay 0.1 ; button delay

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

(fn update [dt]
    (clock:add dt)

    (let [[a b] pos]
    (let [[a0 b0] starting_pos]

        (var max_pos  ( + b0 (* button_spacing (- (length buttons) 1))))
        (var min_pos b0)
        
        (if (clock:expired)
            (do
                ( when (or (love.keyboard.isDown "down") (love.keyboard.isDown "s"))
                    (clock:reset)
                    (if (<= (+ b button_spacing) max_pos)
                        (set pos [a (+ b button_spacing)])
                    )
                )
                (when (or (love.keyboard.isDown "up") (love.keyboard.isDown "w"))
                    (clock:reset)
                    (if (>= (- b button_spacing) min_pos)
                        (set pos [a (- b button_spacing)])
                    )
                )
                (when (love.keyboard.isDown "return")
                    (clock:reset)
                    ;find relative functoin and call it

                    (var button_index (+ (/ (- b b0) button_spacing) 1))
                    (let [button (. buttons button_index )]
                        (var function (. button 2))
                        (function)
                    )                                 
                )
            )
        )

        ;update menu item positions
        (for [i 1 (length buttons)]
            (let [button (. buttons i)]

                (local bx     (. button 3))
                (var by       (. button 4))
                (var ret nil)

                ; indent
                (if (= b (- by 5))
                    (do
                        (set ret (+ a0 25))
                    )
                
                ; unindex
                    (do
                        (set ret (+ a0 5))
                    )
                )

                (tset (. buttons i) 3 ret)
                        
            )
        )
    )
    )
)


{
    :draw draw
    :update update
}