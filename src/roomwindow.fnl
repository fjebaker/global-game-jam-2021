
(local world (require :src.world))

(var world_data world:World)
(var world_lims (. world_data 1))

    (var window_width 100)

    (let [[x_lim y_lim] world_lims]
       ; (love.graphics.print [x_lim ylim] 300 300)

        ; pick random boundary from four walls top = 1 right = 2 etc
        (var wall (math.random 1 4))

        ; pick random point on wall 
        (var wall_loc (math.random 0 (- 4000 window_width)))
    )


;{
;    :wall wall
;    :wall_loc wall_loc
;}