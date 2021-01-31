
LIBS := $(wildcard lib/*)
LUA := $(wildcard *.lua)
ROOT_OUT := $(patsubst %.fnl,%.lua,$(wildcard *.fnl))
SRC_OUT := $(patsubst %.fnl,%.lua,$(wildcard src/*.fnl))
CREEP_OUT := $(patsubst %.fnl,%.lua,$(wildcard src/creeps/*.fnl))
FOOD_OUT := $(patsubst %.fnl,%.lua,$(wildcard src/foods/*.fnl))
COMPILED_OUT := $(ROOT_OUT) $(SRC_OUT) $(CREEP_OUT) $(FOOD_OUT)

run: ; love .

clean: ; rm -rf releases/* $(COMPILED_OUT)

cleansrc: ; rm -rf $(COMPILED_OUT)

%.lua: %.fnl; lua lib/fennel --compile --correlate $< > $@

LOVEFILE=releases/game.love

$(LOVEFILE): $(LUA) $(COMPILED_OUT) $(LIBS) assets
	mkdir -p releases/
	find $^ -type f | sort | zip -r -q -9 -X $@ -@

love: $(LOVEFILE)
