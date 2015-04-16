FLEX_SDK = C:/Flex_sdk
ANDROID_SDK = C:/Android-sdk

SIGN_CERT = sign.pfx
SIGN_PWD = abc123
SWF_VERSION = 11.8

ADT = $(FLEX_SDK)/bin/adt.bat
ADL = $(FLEX_SDK)/bin/adl.exe
AMXMLC = $(FLEX_SDK)/bin/amxmlc
SOURCES = src/*.hx assets/*.png

APP = Game
APP_XML = $(APP).xml
GAME_SWF = $(APP).swf
GAME_APK = $(APP).apk

all: $(GAME_SWF)

apk: $(GAME_APK)

clean:
	rm -rf $(GAME_SWF) $(GAME_APK)
	
test: $(GAME_SWF)
	$(ADL) -profile tv -screensize 1280x720:1280x720 $(APP_XML)
	
test_low: $(GAME_SWF)
	$(ADL) -profile tv -screensize 640x360:640x360 $(APP_XML)
	
test_high: $(GAME_SWF)
	$(ADL) -profile tv -screensize 1280x720:1280x720 $(APP_XML)

sign.pfx:
	$(ADT) -certificate -validityPeriod 25 -cn SelfSigned 1024-RSA $(SIGN_CERT) $(SIGN_PWD)

install: $(GAME_APK)
	$(ADT) -installApp -platform android -platformsdk $(ANDROID_SDK) -package $(GAME_APK)

$(GAME_SWF): $(SOURCES)
	haxe \
	-cp src \
	-cp vendor \
	-swf-header 1280:720:60:ffffff \
	-swf-version $(SWF_VERSION) \
	-main GameLoader \
	-swf $(GAME_SWF) \
	-resource assets/levelone.tmx@levelone \
	-swf-lib vendor/starling_1_6.swc \
	--macro "patchTypes('vendor/starling.patch')" \

game_apk: $(GAME_SWF) $(SIGN_CERT)
	$(ADT) -package -target apk-captive-runtime \
	-storetype pkcs12 -keystore $(SIGN_CERT) $(GAME_APK) $(APP_XML) $(GAME_SWF) \
	assets ouya_icon.png
	