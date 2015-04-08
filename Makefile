FLEX_SDK = C:/Flex_sdk
ADL = $(FLEX_SDK)/bin/adl.exe
AMXMLC = $(FLEX_SDK)/bin/amxmlc
SOURCES = src/*.hx assets/*.png
GAME = Game.swf

all: $(GAME)

$(GAME): $(SOURCES)
	haxe \
	-cp src \
	-cp vendor \
	-swf-header 1280:720:60:ffffff \
	-swf-version 11.8 \
	-main GameLoader \
	-swf $(GAME) \
	-resource assets/levelone.tmx@levelone \
	-swf-lib vendor/starling_1_6.swc \
	--macro "patchTypes('vendor/starling.patch')" \

clean:
	del $(GAME)
	rm -rf $(GAME) ~ src/~

test: $(GAME)
	$(ADL) -profile tv -screensize 1280x720:1280x720 game.xml
