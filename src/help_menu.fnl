(var starting_pos [95 500])
(var pos starting_pos)
(var button_spacing 50)

; make empty table of buttons
(local buttons []) 

;function for adding to table
(fn addButton [text funct]
    (table.insert buttons [text funct]))

;make buttons
(fn but_funct []
    (var state (require :src.state))
    (set state.current "PAUSE")
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
    
        (love.graphics.draw (love.graphics.newImage "assets/final_menu_bg.png") 0 0)

        (love.graphics.print "Kafkaesque - Pause Menu - Help." 100 50)

        (love.graphics.print "You have awoken as a beetle in a world you once knew, you now feel lost \n and vlnerable. Find food and a way to escape this domestic prison...\n\nUse 'W A S D' or arrow keys crawl to freedom." 100 200)

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
                (when (love.keyboard.isDown "return")
                    (love.graphics.print "DEBUG" 400 400)
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