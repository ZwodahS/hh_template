# i.e. Abyss
GAME=GAMENAME
# i.e. Abyss.app
MACAPP=${GAME}.app
# e.g abyss
GAMELOWERCASE=$(shell echo ${GAME} | tr '[:upper:]' '[:lower:]')
BINARY=${GAMELOWERCASE}
# i.e. zwodahs/abyss
ITCH_URL=zwodahs/${GAMELOWERCASE}
# i.e. zwodahs/abyss-beta
ITCH_BETA_URL=zwodahs/${GAMELOWERCASE}-beta

VERSION=$(shell cat src/Constants.hx | grep Version | cut -d '=' -f 2 | sed 's/[; "]//g')
COMPILE_FLAGS=

ifeq (${DEBUG},1)
COMPILE_FLAGS += -D debugger
endif

ifeq (${RELEASE},1)
COMPILE_FLAGS += --no-traces
else
COMPILE_FLAGS += -D debug -D loggingLevel=30
endif

MAC_BUILD_PATH=build/mac
MAC_APP_PATH=${MAC_BUILD_PATH}/${GAME}.app

hl: assets
	@echo "Version ${VERSION}"
	rm -f .breakpoints
	touch .breakpoints
	haxe build_script/common.hxml build_script/hl.hxml ${COMPILE_FLAGS} --hl game.hl --main Game

js: assets pak
	@echo "Version ${VERSION}"
	haxe build_script/common.hxml --js build/js/game.js -D pak ${COMPILE_FLAGS} --main Game
	cp build_script/index.html build/js/.
	cp res.pak build/js/.
	cp res/favicon.png build/js/favicon.ico

gcc: c
	rm -f ./game
	gcc -O3 -o game -I build/c/ build/c/main.c -lhl /usr/local/lib/*.hdll

c: assets
	@echo "Version ${VERSION}"
	haxe build_script/common.hxml build_script/c.hxml --hl build/c/main.c ${COMPILE_FLAGS} --main Game

ios: assets pak
	@echo "Version ${VERSION}"
	haxe build_script/common.hxml build_script/c.hxml -D pak --hl build/ios/main.c ${COMPILE_FLAGS} --main Game
	cp res.pak build/ios/.

mac: assets pak
	@echo "Version ${VERSION}"
	haxe build_script/common.hxml build_script/c.hxml --hl build/c/main.c -D mac -D pak ${COMPILE_FLAGS} --main Game
	rm -rf build/mac
	mkdir build/mac
	# compile
	gcc -O3 -o ${MAC_BUILD_PATH}/${BINARY} -I build/c/ build/c/main.c -lhl /usr/local/lib/*.hdll
	# make the .app
	mkdir ${MAC_APP_PATH}
	mkdir ${MAC_APP_PATH}/Contents
	mkdir ${MAC_APP_PATH}/Contents/MacOS
	mkdir ${MAC_APP_PATH}/Contents/Resources
	cat build_script/mac/Info.plist | sed 's/__APPNAME__/${GAME}/g' | sed 's/__VERSION__/${VERSION}/g' > ${MAC_APP_PATH}/Contents/Info.plist
	cp res/favicon.png ${MAC_APP_PATH}/Contents/Resources/icon.png
	mv ${MAC_BUILD_PATH}/${BINARY} ${MAC_APP_PATH}/Contents/MacOS/.
	cp res.pak ${MAC_APP_PATH}/Contents/Resources/.

lint:
	haxelib run formatter -s src

pak:
	haxe -hl hxd.fmt.pak.Build.hl -lib heaps -main hxd.fmt.pak.Build
	hl hxd.fmt.pak.Build.hl

assets: res/packed.json

res/packed.json: raw/font32.json
	./bin/asepritepack.py res/packed.png:res/packed.json \
		raw/font32.png:raw/font32.json

dist: dist-web dist-mac

dist-web: js
	mkdir -p build/web
	cd build/js; zip ../web/web.zip *

push-web:
	butler push build/web/web.zip ${ITCH_URL}:web --userversion ${VERSION}

push-web-beta:
	butler push build/web/web.zip ${ITCH_BETA_URL}:web --userversion ${VERSION}

dist-mac: mac
	tar -cvf build/mac/mac-${VERSION}.tar build/mac/${MACAPP}
push-mac:
	butler push build/mac/mac-${VERSION}.tar ${ITCH_URL}:mac --userversion ${VERSION}

archive:
	mkdir ${VERSION}
	cp build/web/web.zip ${VERSION}/.
	cp -r build/mac/Abyss.app ${VERSION}/.
	tar -cvf ${VERSION}.tar ${VERSION}
	mv ${VERSION}.tar archives/.
	rm -rf ${VERSION}

clean:
	rm -f ./game
	rm -f ./game.hl
	rm -f -r build/*
