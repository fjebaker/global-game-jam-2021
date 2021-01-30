(var starting_pos [95 95])
(var pos starting_pos)
(var button_spacing 25)

; make empty table of buttons
(local buttons []) 

;function for adding to table
(fn addButton [text funct]
    (table.insert buttons [text funct]))

;make buttons
(fn play_funct []
    (print "play")
)
(addButton "- Play" play_funct)

(fn settings_funct []
    (print "settings")
)
(addButton "- Settings"  settings_funct)

(fn donate_funct []
    (print "donate")
)
(addButton "- Donate to the Devs" donate_funct)

(fn quit_funct []
    (print "quit")
    (love.event.quit 0)
)
(addButton "- Quit"  quit_funct)

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

(fn love.draw []

    (let [[a b] pos]
    
        (love.graphics.draw (love.graphics.newImage "background.png") 0 0)

        (love.graphics.print "K A F K A - Pause Menu." 100 50)

        (love.graphics.rectangle "line" a b 150 button_spacing)

        (for [i 1 (length buttons)]
            (let [button (. buttons i)]

                (var text     (. button 1))
                (var function (. button 2))
                (var bx       (. button 3))
                (var by       (. button 4))

                (love.graphics.print text bx by)
            )   

        )
    )
    
)

(fn love.update [dt]

    (let [[a b] pos]
    (let [[a0 b0] starting_pos]

        (var max_pos  ( + b0 (* button_spacing (- (length buttons) 1))))
        (var min_pos b0)
    
        (when (love.keyboard.isDown "down")


            (if (<= (+ b button_spacing) max_pos)
                (set pos [a (+ b button_spacing)])
            )
        )

        (when (love.keyboard.isDown "up")

            (if (>= (- b button_spacing) min_pos)
                (set pos [a (- b button_spacing)])
            )
        )

        ;update menu item positions
        (for [i 1 (length buttons)]
            (let [button (. buttons i)]

                (var bx       (. button 3))
                (var by       (. button 4))
            
                (if (= b (- by 5))
                    (do
                        (table.remove button 3)
                        (table.insert button 3 (+ bx 20))
                    )
                )
            )
        )
    )
    )
)