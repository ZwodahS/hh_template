GAME=GAMENAME
MACAPP=${GAME}.app
FOLDERNAME=gamename
ITCH_URL=zwodahs/gamename
VERSION=$(shell cat src/Constants.hx | grep Version | cut -d '=' -f 2 | sed 's/[; "]//g')
GIT_HASH=$(shell git rev-parse HEAD)
BUILDSTRING=${VERSION}-${GIT_HASH}

## Set compile flags
COMPILE_FLAGS=

ifeq (${RELEASE},1)
COMPILE_FLAGS += --no-traces
else
COMPILE_FLAGS += -D debug -D loggingLevel=30
endif

JS_BUILD_PATH=build/js
MAC_BUILD_PATH=build/mac
MAC_APP_PATH=${MAC_BUILD_PATH}/${MACAPP}
WINDOWS_BUILD_PATH=build/windows
WINDOWS_APP_PATH=${WINDOWS_BUILD_PATH}/${FOLDERNAME}

ifndef OS
OS = $(shell uname -s)
endif

BINARY_FLAGS=
ifeq ($(OS),Windows_NT)
BINARY_FLAGS += --library hldx
else ifeq ($(OS),Darwin)
BINARY_FLAGS += --library hlsdl
endif

ifndef HAXEPATH
HAXEPATH=$(shell which haxe | xargs dirname)
endif

ifndef HASHLINKPATH
HASHLINKPATH=$(shell which hl | xargs dirname)
endif

game.hl: buildinfo assets
	${HAXEPATH}/haxe build_script/common.hxml build_script/hl.hxml ${COMPILE_FLAGS} ${BINARY_FLAGS} --hl game.hl --main Game

buildinfo:
	@echo "OS                    : ${OS}"
	@echo "HAXE VERSION          : $(shell ${HAXEPATH}/haxe --version) from ${HAXEPATH}"
	@echo "HASHLINK VERSION      : $(shell ${HASHLINKPATH}/hl --version) from ${HASHLINKPATH}"
	@echo "Building Game Version : ${VERSION}"
	@echo "Flags                 : ${COMPILE_FLAGS} ${BINARY_FLAGS}"
	@echo "Build Version         : ${BUILDSTRING}"
	@echo ""

js: buildinfo assets pak
	${HAXEPATH}/haxe build_script/common.hxml --js ${JS_BUILD_PATH}/game.js -D pak ${COMPILE_FLAGS} --main Game
	cp build_script/index.html ${JS_BUILD_PATH}/.
	cp build/res.pak ${JS_BUILD_PATH}/.
	cp res/favicon.png ${JS_BUILD_PATH}/favicon.ico
	cp -r build_script/licenses ${JS_BUILD_PATH}/licenses

# use hl for mac
mac: buildinfo assets pak
	rm -rf ${MAC_APP_PATH}
	mkdir -p ${MAC_APP_PATH}
	mkdir -p ${MAC_APP_PATH}/Contents
	mkdir -p ${MAC_APP_PATH}/Contents/MacOS
	mkdir -p ${MAC_APP_PATH}/Contents/Resources
	mkdir -p ${MAC_APP_PATH}/Contents/Frameworks
	${HAXEPATH}/haxe build_script/common.hxml build_script/hl.hxml ${COMPILE_FLAGS} --library hlsdl -D mac -D pak --hl build/mac/hlboot.dat --main Game
	cat build_script/mac/Info.plist | sed 's/__VERSION__/${VERSION}/g' > ${MAC_APP_PATH}/Contents/Info.plist
	cp res/favicon.png ${MAC_APP_PATH}/Contents/Resources/icon.png
	mv build/mac/hlboot.dat ${MAC_APP_PATH}/Contents/MacOS/.
	cp build_script/mac/run.sh ${MAC_APP_PATH}/Contents/MacOS/.
	cp build_script/mac/hl ${MAC_APP_PATH}/Contents/MacOS/.
	cp build_script/mac/*.hdll ${MAC_APP_PATH}/Contents/Frameworks/.
	cp build_script/mac/*.dylib ${MAC_APP_PATH}/Contents/Frameworks/.
	cp build/res.pak ${MAC_APP_PATH}/Contents/Resources/.
	cp -r build_script/licenses ${MAC_APP_PATH}/Contents/Licenses

# use hl for windows
windows: buildinfo assets pak
	rm -rf ${WINDOWS_BUILD_PATH}
	mkdir -p ${WINDOWS_BUILD_PATH}
	mkdir -p ${WINDOWS_APP_PATH}
	${HAXEPATH}/haxe build_script/common.hxml build_script/hl.hxml ${COMPILE_FLAGS} --library hldx -D windows -D pak --hl ${WINDOWS_APP_PATH}/hlboot.dat --main Game
	cp build/res.pak ${WINDOWS_APP_PATH}/.
	cp build_script/windows/hl.exe ${WINDOWS_APP_PATH}/${GAME}.exe
	cp build_script/windows/fmt.hdll ${WINDOWS_APP_PATH}/.
	cp build_script/windows/openal.hdll ${WINDOWS_APP_PATH}/.
	cp build_script/windows/directx.hdll ${WINDOWS_APP_PATH}/.
	cp build_script/windows/ui.hdll ${WINDOWS_APP_PATH}/.
	cp build_script/windows/libhl.dll ${WINDOWS_APP_PATH}/.
	cp build_script/windows/msvcr120.dll ${WINDOWS_APP_PATH}/.
	cp build_script/windows/OpenAL32.dll ${WINDOWS_APP_PATH}/.
	cp -r build_script/licenses ${WINDOWS_APP_PATH}/licenses

lint:
	haxelib run formatter -s src

pak:
	mkdir -p build
	${HAXEPATH}/haxe -hl hxd.fmt.pak.Build.hl -lib heaps -lib hlsdl -main hxd.fmt.pak.Build
	${HASHLINKPATH}/hl hxd.fmt.pak.Build.hl
	-mv res.pak build/.

GRAPHICS_PATH=res/graphics/

assets: assetsmove ${GRAPHICS_PATH}/packed.json

assetsmove:
	-mv assets/ase/*.json raw/. 2> /dev/null
	-mv assets/ase/*.png raw/. 2> /dev/null

asset_jsons = $(shell ls raw/*.json)
asset_pngs = $(shell ls raw/*.png)

${GRAPHICS_PATH}/packed.json: ${asset_jsons} ${asset_pngs}
	./bin/asepritepack.py ${GRAPHICS_PATH}/packed.png:${GRAPHICS_PATH}/packed.json \
		raw/font32.png:raw/font32.json

# we can run dist in mac for windows as well, just need to build it with hldx instead.
dist: dist-web dist-mac dist-windows

dist-web: js
	mkdir -p build/web
	cd ${JS_BUILD_PATH}; zip ../web/web.zip *

MAC_DIST=${GAME}-mac-${VERSION}.zip
dist-mac: mac
	mkdir -p build/mac/${FOLDERNAME}
	cp -r build/mac/${MACAPP} build/mac/${FOLDERNAME}/.
	cp build_script/mac/README.txt build/mac/${FOLDERNAME}/.
	cd build/mac; zip -r ${MAC_DIST} ${FOLDERNAME}

WINDOWS_DIST=${GAME}-windows-${VERSION}.zip
dist-windows: windows
	cd build/windows; zip -r ${WINDOWS_DIST} ${FOLDERNAME}

push-all: push-web push-mac push-windows

push-web:
	butler push build/web/web.zip ${ITCH_URL}:web --userversion ${VERSION}

push-mac:
	butler push build/mac/${MAC_DIST} ${ITCH_URL}:mac --userversion ${VERSION}

push-windows:
	butler push build/windows/${WINDOWS_DIST} ${ITCH_URL}:windows --userversion ${VERSION}

archive:
	mkdir -p releases
	mkdir -p ${BUILDSTRING}
	cp build/web/web.zip ${BUILDSTRING}/.
	cp build/mac/${MAC_DIST} ${BUILDSTRING}/.
	cp build/windows/${WINDOWS_DIST} ${BUILDSTRING}/.
	mkdir -p ${BUILDSTRING}/working
	cp -r res ${BUILDSTRING}/working/res
	cp game.hl ${BUILDSTRING}/working/.
	tar -cvf ${BUILDSTRING}.tar ${BUILDSTRING}
	mv ${BUILDSTRING}.tar releases/.
	rm -rf ${BUILDSTRING}

clean:
	rm -f ./game.hl
	rm -f -r build/*
