
LIBS := $(wildcard lib/*)
LUA := $(wildcard *.lua)
SRC := $(wildcard *.fnl)
OUT := $(patsubst %.fnl,%.lua,$(SRC))

run: ; love .

clean: ; rm -rf releases/* $(OUT)

cleansrc: ; rm -rf $(OUT)

%.lua: %.fnl; lua lib/fennel --compile --correlate $< > $@

LOVEFILE=releases/game.love

$(LOVEFILE): $(LUA) $(OUT) $(LIBS)
	mkdir -p releases/
	find $^ -type f | sort | zip -r -q -9 -X $@ -@

love: $(LOVEFILE)
