
(fn tmerge [a b]
    ; merges table b into table a
    (each [key _ (pairs a)]
        (if (. b key)
            (tset a key (. b key))
            ; else
        )
    )
)

(fn tcopy [t]
    ; deep copy
    (let [c {}]
        (each [key value (pairs t)]
            (tset c key value)
        )
        c
    )
)

(fn tadd [dest t]
    ; adds fields and values of t into dest with overriding
    (each [key value (pairs t)]
        (tset dest key value)
    )
)

(fn tloadimage [instance midx midy]
    ; replaces :image of self with a love Image instance
    (set instance.image (love.graphics.newImage instance.image))
    (let [
        width (love.graphics.getPixelWidth instance.image)
        height (love.graphics.getPixelHeight instance.image)
        ]
        (set instance.X_MID midx)
        (set instance.Y_MID midy)
    )
)

(fn tmap [func arr]
    ; maps function func onto each element in arr
    (each [_ obj (ipairs arr)]
        (func obj)
    )
)

(fn tmapupdate [arr dt]
    ; calls update of each element in arr with dt
    (each [_ obj (ipairs arr)]
        (obj:update dt)
    )
)


{
    :tcopy tcopy 
    :tmerge tmerge 
    :tadd tadd 
    :tloadimage tloadimage
    :tmap tmap
    :tmapupdate tmapupdate
}