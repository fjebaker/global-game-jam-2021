; IMPORTS
(local utils (require :src.utils))
(local view (require :lib.fennelview))

(local button-spacing 50)
(local selected-indent 20)

(fn bump-index [self delta]
    (let [idx self.selected-index
          max (length self.buttons)
          new-idx (+ idx delta)]
        (if (< new-idx 1)
            (set self.selected-index max)
            (<= new-idx max)
            (set self.selected-index new-idx)
            (set self.selected-index 1)
        )
    )
)

(fn draw-buttons [buttons x y selected-index]
    (each [idx butt (ipairs buttons)]
        (let [offset (if (= idx selected-index) selected-indent 0)
              bx (+ x offset)
              by (+ y (* idx button-spacing))]
            (love.graphics.print butt.text bx by)
        )
    )
)

(macro with-font [font func]
    "Run some code with a temporary font setting"
    `(if (not= nil ,font)
        (let [saved# (love.graphics.getFont)]
            (love.graphics.setFont ,font)
            ,func
            (love.graphics.setFont saved#)
        )
        ; else
        ,func
    )
)

; METHODS

(fn draw [self]
    (love.graphics.draw
        self.image
        self.img-x self.img-y 0
        self.img-scale self.img-scale
    )
    (each [_ text (ipairs self.texts)]
        (with-font text.font
            (love.graphics.print text.text (unpack text.position))
        )
    )
    (let [(x y) (unpack self.buttongroup.position)
          selected-index self.buttongroup.selected-index]
        (with-font self.buttongroup.font
            (draw-buttons self.buttongroup.buttons x y selected-index)
        )
    )
)

(fn keypressed [self key isrepeat]
    (let [idx self.buttongroup.selected-index]
        (if (= key "down")
            (self.buttongroup:bump 1)
            (= key "up")
            (self.buttongroup:bump -1)
            (= key "return")
            (let [button (. self.buttongroup.buttons idx)]
                (: button :function)
            )
        )
    )
)

(fn update [self dt]
)

; INTERFACE

(local Button {
    :text ""
    :function (lambda [])
})

(local ButtonGroup {
    :buttons []
    :font nil
    :position [0 0]
    :selected-index 1

    :bump bump-index
})

(local Text {
    :text ""
    :font nil
    :position [0 0]
})

(local Menu {
    :image ""
    :img-x 0
    :img-y 0
    :img-scale 1.0
    :texts []
    :buttongroup nil

    :draw draw
    :keypressed keypressed
    :update update
})

; CONSTRUCTOR

(fn newbutton [text function]
    (let [instance {}]
        (utils.tadd instance Button)
        (set instance.text text)
        (set instance.function function)

        instance
    )
)

(fn newbuttongroup [buttons position font selected]
    (let [instance {}]
        (utils.tadd instance ButtonGroup)
        (set instance.buttons buttons)
        (set instance.position position)
        (set instance.font font)
        (when (not= nil selected)
            (set instance.selected-index selected)
        )

        instance
    )
)

(fn newtext [text position font]
    (let [instance {}]
        (utils.tadd instance Text)
        (set instance.text text)
        (set instance.position position)
        (set instance.font font)

        instance
    )
)

(fn new [attributes]
    (let [instance []]
        (utils.tadd instance Menu)
        (utils.tadd instance attributes)

        ; load image from path
        (utils.tloadimage instance)

        instance
    )
)

; MODULE EXPORTS
{
    :new new
    :newbutton newbutton
    :newbuttongroup newbuttongroup
    :newtext newtext
}
