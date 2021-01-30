
(fn playsongloop []
    (let [song (love.audio.newSource "assets/kafka.mp3" :stream)]
        (song:setLooping true)
        (song:play)
    )
)

{ :playsongloop playsongloop }