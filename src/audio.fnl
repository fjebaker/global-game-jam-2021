
(fn playsongloop []
    (let [song (love.audio.newSource "assets/kafka.mp3" :stream)]
        (song:setLooping true)
        (song:play)
    )
)

(fn playwin []
    (let [song (love.audio.newSource "assets/win.mp3" :stream)]
        (song:play)
    )
)

(fn playlose []
    (let [song (love.audio.newSource "assets/lose.mp3" :stream)]
        (song:play)
    )
)

{ :playsongloop playsongloop :playwin playwin :playlose playlose}