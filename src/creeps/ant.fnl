

(local hitbox (
    let [HitBox (require :src.hitbox)]
        (HitBox.new 10) ; RADIUS
    )
)


{
    :MAX_CLOCK 2000
    :MIN_CLOCK 100
    :MAX_VEL 50

    :image "assets/ant.jpg"
    :hitbox hitbox
}
