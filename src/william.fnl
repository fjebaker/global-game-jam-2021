
(local NUM_QUOTES 15)
(local quotes [])


(local voiceclock {
    :integrator 0
    :delay 30 ; button delay

    :reset (fn reset [self] 
        (set self.integrator 0)
    )
    :expired (fn expired [self] 
        (> self.integrator self.delay)
    )
    :add (fn add [self dt] 
        (set self.integrator (+ self.integrator dt))
    )
    
    :newdelay (fn newdelay [self]
        (set self.delay (math.random 30 60))
    )
})

(fn playrandom []
    (let [
        choice (math.random 1 (length quotes))
        wav (love.audio.newSource (. quotes choice) :stream)
        ]
        (wav:play)
    )
)

(fn update [dt]
    (voiceclock:add dt)
    (if (voiceclock:expired)
        (do 
            (voiceclock:reset)
            (playrandom)
            (voiceclock:newdelay)
        )
    )
)


(fn loadquotes []
    (for [i 1 NUM_QUOTES]
        (tset quotes i (.. "assets/voice/quote" i ".wav"))
    )
)




{:loadquotes loadquotes :playrandom playrandom :update update}