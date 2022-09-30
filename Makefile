########################################################################################################################
# Constants - NO NEED TO CHANGE THIS
VERSION=$(shell cat src/Constants.hx | grep Version | cut -d '(' -f 2 | sed 's/[\); "]//g')
GIT_HASH=$(shell git rev-parse HEAD)
BUILDSTRING=${VERSION}-${GIT_HASH}

ifndef OS
OS = $(shell uname -s)
endif

ifndef HAXEPATH
HAXEPATH=$(shell which haxe | xargs dirname)
endif

ifndef HASHLINKPATH
HASHLINKPATH=$(shell which hl | xargs dirname)
endif
########################################################################################################################
# Configure this for each games
## Generic configuration
GAME=GameName # @configure
GAMENAME=GameName # @configure, for index.html and Info.plist
MACAPP=${GAME}.app
FOLDERNAME=GameName # @configure
## Deployment configuration
### Itch configuration
ITCH_URL=zwodahs/????? # @configure
PRIVATE_ITCH_URL=zwodahs/???? # @configure
### Steam Configuration
STEAM_APP_ID= # @configure
STEAM_WINDOWS_DEPOT_ID= # @configure
STEAM_MAC_DEPOT_ID= # @configure
STEAM_LINUX_DEPOT_ID= # @configure
### Steam Demo Configuration
STEAM_DEMO_APP_ID= # @configure
STEAM_DEMO_WINDOWS_DEPOT_ID= # @configure
STEAM_DEMO_MAC_DEPOT_ID= # @configure
STEAM_DEMO_LINUX_DEPOT_ID= # @configure
########################################################################################################################
# Compilation & Build configuration - Do not change this section
## Set compile flags
COMPILE_FLAGS=
ifeq (${RELEASE},1)
COMPILE_FLAGS += --no-traces
else
COMPILE_FLAGS += -D debug -D loggingLevel=30
endif

# If SteamSDK is enabled.
STEAMAPI_CFLAGS=
ifeq ($(STEAMAPI),1)
STEAMAPI_CFLAGS=-D steamapi --library hlsteam
endif

## Set Build path
### JS
JS_BUILD_PATH=build/js
### MAC
MAC_BUILD_PATH=build/mac
MAC_APP_PATH=${MAC_BUILD_PATH}/${MACAPP}
MAC_DIST=${GAME}-mac-${VERSION}.zip
### WINDOWS
WINDOWS_BUILD_PATH=build/windows
WINDOWS_APP_PATH=${WINDOWS_BUILD_PATH}/${FOLDERNAME}
WINDOWS_DIST=${GAME}-windows-${VERSION}.zip
### LINUX
LINUX_BUILD_PATH=build/linux
LINUX_APP_PATH=${LINUX_BUILD_PATH}/${FOLDERNAME}
LINUX_DIST=${GAME}-linux-${VERSION}.zip
### Steam
STEAM_BUILD_PATH=build/steam
STEAM_WINDOWS_BUILD_PATH=build/steam/content/windows
STEAM_MAC_BUILD_PATH=build/steam/content/mac
STEAM_LINUX_BUILD_PATH=build/steam/content/linux
STEAM_BUILD_FILE=app_build_${STEAM_APP_ID}.vdf
### Steam-Demo
STEAM_DEMO_BUILD_PATH=build/steam-demo
STEAM_DEMO_WINDOWS_BUILD_PATH=build/steam-demo/content/windows
STEAM_DEMO_MAC_BUILD_PATH=build/steam-demo/content/mac
STEAM_DEMO_LINUX_BUILD_PATH=build/steam-demo/content/linux
STEAM_DEMO_BUILD_FILE=app_build_${STEAM_DEMO_APP_ID}.vdf
########################################################################################################################
# Binary flags for local compile flags during debugging
BINARY_FLAGS= --library hlsdl
########################################################################################################################
#
# Local build
game.hl: buildinfo strings assets
	${HAXEPATH}/haxe build_script/common.hxml build_script/hl.hxml ${COMPILE_FLAGS} ${BINARY_FLAGS} --hl game.hl --main Game

# Local build with pak
pakgame: buildinfo strings assets pak
	${HAXEPATH}/haxe build_script/common.hxml build_script/hl.hxml ${COMPILE_FLAGS} ${BINARY_FLAGS} -D pak --hl game.hl --main Game

# combine the string utility
stringutil:
	${HAXEPATH}/haxe --class-path tools --library zf --hl bin/combinestrings --main CombineStringTable

# print build information
buildinfo:
	@echo "OS                    : ${OS}"
	@echo "HAXE VERSION          : $(shell ${HAXEPATH}/haxe --version) from ${HAXEPATH}"
	@echo "HASHLINK VERSION      : $(shell ${HASHLINKPATH}/hl --version) from ${HASHLINKPATH}"
	@echo "Building Game Version : ${VERSION}"
	@echo "Flags                 : ${COMPILE_FLAGS} ${BINARY_FLAGS}"
	@echo "Build Version         : ${BUILDSTRING}"
	@echo ""

# help menu
help:
	@echo "---- Distribution commands ----"
	@echo "  steam - build both steam-windows and steam-mac"
	@echo "  steam-demo - build both steam-demo-windows and steam-demo-mac"
	@echo "  dist - build distribution for RELEASE"
	@echo "---- Push commands ----"
	@echo "  push-all - push-web push-mac push-windows"
	@echo "  push-web - push to itch web"
	@echo "  push-mac - push to itch mac (.app)"
	@echo "  push-windows - push to itch windows"
	@echo "  push-steam - push release build to steam"
	@echo "  push-steam-demo - push demo build to steam"
	@echo "---- Build commands ----"
	@echo "-- Releases --"
	@echo "  js - build for js"
	@echo "  mac - build a mac.app"
	@echo "  windows - build for windows"
	@echo "  steam-windows - build for steam windows with the steam build script"
	@echo "  steam-mac - build for steam mac with the steam build script"
	@echo "-- Demo ---"
	@echo "  steam-demo-windows - build demo for steam windows with the steam build script"
	@echo "  steam-demo-mac - build demo for steam mac with the steam build script"
	@echo "-- Others ---"
	@echo "stringutil string utility"

# build js
js: buildinfo strings assets pak
	${HAXEPATH}/haxe build_script/common.hxml --js ${JS_BUILD_PATH}/game.js -D pak ${COMPILE_FLAGS} --main Game
	cp build_script/index.html ${JS_BUILD_PATH}/.
	cp build/res.pak ${JS_BUILD_PATH}/.
	cp res/favicon.png ${JS_BUILD_PATH}/favicon.ico
	cp -r build_script/licenses ${JS_BUILD_PATH}/licenses

demo-js: buildinfo strings assets pak
	${HAXEPATH}/haxe build_script/common.hxml --js ${JS_BUILD_PATH}/game.js -D pak -D demo ${COMPILE_FLAGS} --main Game
	cp build_script/index.html ${JS_BUILD_PATH}/.
	cp build/res.pak ${JS_BUILD_PATH}/.
	cp res/favicon.png ${JS_BUILD_PATH}/favicon.ico
	cp -r build_script/licenses ${JS_BUILD_PATH}/licenses

steam-test: buildinfo
	steamcmd +login ${STEAM_USER} +quit

# use hl for mac
mac: buildinfo strings assets pak
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

# use hl for linux
linux: buildinfo strings assets pak
	rm -rf ${LINUX_BUILD_PATH}
	mkdir -p ${LINUX_BUILD_PATH}
	mkdir -p ${LINUX_APP_PATH}
	${HAXEPATH}/haxe build_script/common.hxml build_script/hl.hxml ${COMPILE_FLAGS} --library hlsdl -D linux -D pak --hl build/linux/hlboot.dat --main Game
	cp build/res.pak ${LINUX_APP_PATH}/.
	cp build_script/linux/hl ${LINUX_APP_PATH}/${GAME}
	cp build_script/linux/*.hdll ${LINUX_APP_PATH}/.
	cp build_script/linux/*.so* ${LINUX_APP_PATH}/.
	cp build_script/linux/run.sh ${LINUX_APP_PATH}/.
	cp -r build_script/licenses ${LINUX_APP_PATH}/licenses

# use hl for windows
windows: buildinfo strings assets pak
	rm -rf ${WINDOWS_BUILD_PATH}
	mkdir -p ${WINDOWS_BUILD_PATH}
	mkdir -p ${WINDOWS_APP_PATH}
	${HAXEPATH}/haxe build_script/common.hxml build_script/hl.hxml ${COMPILE_FLAGS} --library hlsdl -D windows-sdl -D pak --hl ${WINDOWS_APP_PATH}/hlboot.dat --main Game
	cp build/res.pak ${WINDOWS_APP_PATH}/.
	cp build_script/windows-sdl/hl.exe ${WINDOWS_APP_PATH}/${GAME}.exe
	cp build_script/windows-sdl/*.hdll ${WINDOWS_APP_PATH}/.
	cp build_script/windows-sdl/*.dll ${WINDOWS_APP_PATH}/.
	cp -r build_script/licenses ${WINDOWS_APP_PATH}/licenses

#### steam ####
steam: buildinfo steam-pre-build steam-windows steam-mac steam-linux
	cat build_script/steam/app.build.template.vdf \
		| sed 's/__VERSION__/${BUILDSTRING}/g' \
		| sed 's/__APP_ID__/${STEAM_APP_ID}/g' \
		| sed 's/__WINDOWS_DEPOT_ID__/${STEAM_WINDOWS_DEPOT_ID}/g' \
		| sed 's/__MAC_DEPOT_ID__/${STEAM_MAC_DEPOT_ID}/g' \
		| sed 's/__LINUX_DEPOT_ID__/${STEAM_LINUX_DEPOT_ID}/g' \
		> ${STEAM_BUILD_PATH}/${STEAM_BUILD_FILE}
	cat build_script/steam/depot.windows.vdf \
		| sed 's/__VERSION__/${BUILDSTRING}/g' \
		| sed 's/__APP_ID__/${STEAM_APP_ID}/g' \
		| sed 's/__WINDOWS_DEPOT_ID__/${STEAM_WINDOWS_DEPOT_ID}/g' \
		| sed 's/__MAC_DEPOT_ID__/${STEAM_MAC_DEPOT_ID}/g' \
		| sed 's/__LINUX_DEPOT_ID__/${STEAM_LINUX_DEPOT_ID}/g' \
		> ${STEAM_BUILD_PATH}/depot_windows.vdf
	cat build_script/steam/depot.mac.vdf \
		| sed 's/__VERSION__/${BUILDSTRING}/g' \
		| sed 's/__APP_ID__/${STEAM_APP_ID}/g' \
		| sed 's/__WINDOWS_DEPOT_ID__/${STEAM_WINDOWS_DEPOT_ID}/g' \
		| sed 's/__MAC_DEPOT_ID__/${STEAM_MAC_DEPOT_ID}/g' \
		| sed 's/__LINUX_DEPOT_ID__/${STEAM_LINUX_DEPOT_ID}/g' \
		> ${STEAM_BUILD_PATH}/depot_mac.vdf
	cat build_script/steam/depot.linux.vdf \
		| sed 's/__VERSION__/${BUILDSTRING}/g' \
		| sed 's/__APP_ID__/${STEAM_APP_ID}/g' \
		| sed 's/__WINDOWS_DEPOT_ID__/${STEAM_WINDOWS_DEPOT_ID}/g' \
		| sed 's/__MAC_DEPOT_ID__/${STEAM_MAC_DEPOT_ID}/g' \
		| sed 's/__LINUX_DEPOT_ID__/${STEAM_LINUX_DEPOT_ID}/g' \
		> ${STEAM_BUILD_PATH}/depot_linux.vdf

steam-pre-build: strings assets pak
	rm -rf ${STEAM_BUILD_PATH}
	mkdir -p ${STEAM_BUILD_PATH}
	mkdir -p ${STEAM_WINDOWS_BUILD_PATH}
	mkdir -p ${STEAM_MAC_BUILD_PATH}
	mkdir -p ${STEAM_BUILD_PATH}/build

steam-windows:
	${HAXEPATH}/haxe build_script/common.hxml build_script/hl.hxml ${STEAMAPI_CFLAGS} ${COMPILE_FLAGS} --library hlsdl -D windows -D steam -D pak --hl ${STEAM_WINDOWS_BUILD_PATH}/hlboot.dat --main Game
	cp build/res.pak ${STEAM_WINDOWS_BUILD_PATH}/.
	cp build_script/windows-sdl/hl.exe ${STEAM_WINDOWS_BUILD_PATH}/${GAME}.exe
	cp build_script/windows-sdl/*.hdll ${STEAM_WINDOWS_BUILD_PATH}/.
	cp build_script/windows-sdl/*.dll ${STEAM_WINDOWS_BUILD_PATH}/.
	cp build_script/windows-steam/* ${STEAM_WINDOWS_BUILD_PATH}/.
	cp -r build_script/licenses ${STEAM_WINDOWS_BUILD_PATH}/licenses

steam-mac:
	mkdir -p ${STEAM_MAC_BUILD_PATH}/licenses
	${HAXEPATH}/haxe build_script/common.hxml build_script/hl.hxml ${COMPILE_FLAGS} --library hlsdl -D mac -D steam -D pak --hl ${STEAM_MAC_BUILD_PATH}/hlboot.dat --main Game
	cp build_script/mac/hl ${STEAM_MAC_BUILD_PATH}/.
	cp build_script/mac/*.hdll ${STEAM_MAC_BUILD_PATH}/.
	cp build_script/mac/*.dylib ${STEAM_MAC_BUILD_PATH}/.
	cp build/res.pak ${STEAM_MAC_BUILD_PATH}/.
	cp build_script/mac-steam/* ${STEAM_MAC_BUILD_PATH}/.
	cp -r build_script/licenses ${STEAM_MAC_BUILD_PATH}/licenses

steam-linux:
	mkdir -p ${STEAM_DEMO_LINUX_BUILD_PATH}/
	${HAXEPATH}/haxe build_script/common.hxml build_script/hl.hxml ${COMPILE_FLAGS} --library hlsdl -D linux -D steam -D pak --hl ${STEAM_LINUX_BUILD_PATH}/hlboot.dat --main Game
	cp build_script/linux/hl ${STEAM_LINUX_BUILD_PATH}/.
	cp build_script/linux/*.hdll ${STEAM_LINUX_BUILD_PATH}/.
	cp build_script/linux/*.so* ${STEAM_LINUX_BUILD_PATH}/.
	cp build_script/linux/run.sh ${STEAM_LINUX_BUILD_PATH}/.
	cp build/res.pak ${STEAM_LINUX_BUILD_PATH}/.
	cp build_script/linux-steam/* ${STEAM_LINUX_BUILD_PATH}/.
	cp -r build_script/licenses ${STEAM_LINUX_BUILD_PATH}/licenses

#### demo ####
## steam

steam-demo: buildinfo steam-demo-pre-build steam-demo-windows steam-demo-mac steam-demo-linux
	cat build_script/steam/app.build.template.vdf \
		| sed 's/__VERSION__/${BUILDSTRING}/g' \
		| sed 's/__APP_ID__/${STEAM_DEMO_APP_ID}/g' \
		| sed 's/__WINDOWS_DEPOT_ID__/${STEAM_DEMO_WINDOWS_DEPOT_ID}/g' \
		| sed 's/__MAC_DEPOT_ID__/${STEAM_DEMO_MAC_DEPOT_ID}/g' \
		| sed 's/__LINUX_DEPOT_ID__/${STEAM_DEMO_LINUX_DEPOT_ID}/g' \
		> ${STEAM_DEMO_BUILD_PATH}/${STEAM_DEMO_BUILD_FILE}
	cat build_script/steam/depot.windows.vdf \
		| sed 's/__VERSION__/${BUILDSTRING}/g' \
		| sed 's/__APP_ID__/${STEAM_DEMO_APP_ID}/g' \
		| sed 's/__WINDOWS_DEPOT_ID__/${STEAM_DEMO_WINDOWS_DEPOT_ID}/g' \
		| sed 's/__MAC_DEPOT_ID__/${STEAM_DEMO_MAC_DEPOT_ID}/g' \
		| sed 's/__LINUX_DEPOT_ID__/${STEAM_DEMO_LINUX_DEPOT_ID}/g' \
		> ${STEAM_DEMO_BUILD_PATH}/depot_windows.vdf
	cat build_script/steam/depot.mac.vdf \
		| sed 's/__VERSION__/${BUILDSTRING}/g' \
		| sed 's/__APP_ID__/${STEAM_DEMO_APP_ID}/g' \
		| sed 's/__WINDOWS_DEPOT_ID__/${STEAM_DEMO_WINDOWS_DEPOT_ID}/g' \
		| sed 's/__MAC_DEPOT_ID__/${STEAM_DEMO_MAC_DEPOT_ID}/g' \
		| sed 's/__LINUX_DEPOT_ID__/${STEAM_DEMO_LINUX_DEPOT_ID}/g' \
		> ${STEAM_DEMO_BUILD_PATH}/depot_mac.vdf
	cat build_script/steam/depot.linux.vdf \
		| sed 's/__VERSION__/${BUILDSTRING}/g' \
		| sed 's/__APP_ID__/${STEAM_DEMO_APP_ID}/g' \
		| sed 's/__WINDOWS_DEPOT_ID__/${STEAM_DEMO_WINDOWS_DEPOT_ID}/g' \
		| sed 's/__MAC_DEPOT_ID__/${STEAM_DEMO_MAC_DEPOT_ID}/g' \
		| sed 's/__LINUX_DEPOT_ID__/${STEAM_DEMO_LINUX_DEPOT_ID}/g' \
		> ${STEAM_DEMO_BUILD_PATH}/depot_linux.vdf

steam-demo-pre-build: strings assets pak
	rm -rf ${STEAM_DEMO_BUILD_PATH}
	mkdir -p ${STEAM_DEMO_BUILD_PATH}
	mkdir -p ${STEAM_DEMO_WINDOWS_BUILD_PATH}
	mkdir -p ${STEAM_DEMO_MAC_BUILD_PATH}
	mkdir -p ${STEAM_DEMO_LINUX_BUILD_PATH}
	mkdir -p ${STEAM_DEMO_BUILD_PATH}/build

steam-demo-windows:
	${HAXEPATH}/haxe build_script/common.hxml build_script/hl.hxml ${COMPILE_FLAGS} --library hldx -D windows -D steam -D demo -D pak --hl ${STEAM_DEMO_WINDOWS_BUILD_PATH}/hlboot.dat --main Game
	cp build/res.pak ${STEAM_DEMO_WINDOWS_BUILD_PATH}/.
	cp build_script/windows-sdl/hl.exe ${STEAM_DEMO_WINDOWS_BUILD_PATH}/${GAME}Demo.exe
	cp build_script/windows-sdl/*.hdll ${STEAM_DEMO_WINDOWS_BUILD_PATH}/.
	cp build_script/windows-sdl/*.dll ${STEAM_DEMO_WINDOWS_BUILD_PATH}/.
	cp -r build_script/licenses ${STEAM_DEMO_WINDOWS_BUILD_PATH}/licenses

steam-demo-mac:
	mkdir -p ${STEAM_DEMO_MAC_BUILD_PATH}/licenses
	${HAXEPATH}/haxe build_script/common.hxml build_script/hl.hxml ${COMPILE_FLAGS} --library hlsdl -D mac -D steam -D demo -D pak --hl ${STEAM_DEMO_MAC_BUILD_PATH}/hlboot.dat --main Game
	cp build_script/mac/hl ${STEAM_DEMO_MAC_BUILD_PATH}/.
	cp build_script/mac/*.hdll ${STEAM_DEMO_MAC_BUILD_PATH}/.
	cp build_script/mac/*.dylib ${STEAM_DEMO_MAC_BUILD_PATH}/.
	cp build/res.pak ${STEAM_DEMO_MAC_BUILD_PATH}/.
	cp -r build_script/licenses ${STEAM_DEMO_MAC_BUILD_PATH}/licenses

steam-demo-linux:
	mkdir -p ${STEAM_DEMO_LINUX_BUILD_PATH}/
	${HAXEPATH}/haxe build_script/common.hxml build_script/hl.hxml ${COMPILE_FLAGS} --library hlsdl -D linux -D steam -D demo -D pak --hl ${STEAM_DEMO_LINUX_BUILD_PATH}/hlboot.dat --main Game
	cp build_script/linux/hl ${STEAM_DEMO_LINUX_BUILD_PATH}/.
	cp build_script/linux/*.hdll ${STEAM_DEMO_LINUX_BUILD_PATH}/.
	cp build_script/linux/*.so* ${STEAM_DEMO_LINUX_BUILD_PATH}/.
	cp build_script/linux/run.sh ${STEAM_DEMO_LINUX_BUILD_PATH}/.
	cp build/res.pak ${STEAM_DEMO_LINUX_BUILD_PATH}/.
	cp -r build_script/licenses ${STEAM_DEMO_LINUX_BUILD_PATH}/licenses

##############################
lint:
	haxelib run formatter -s src

pak:
	mkdir -p build
	${HAXEPATH}/haxe -hl hxd.fmt.pak.Build.hl -lib heaps -lib hlsdl -main hxd.fmt.pak.Build
	${HASHLINKPATH}/hl hxd.fmt.pak.Build.hl
	-cp res.pak build/.

########################################## PARSE STRINGS FOR I8N #######################################################
strings_path = res/strings
# parse strings
strings: res/strings/en/strings.json

en_strings_files = $(shell find data -name '*.xml')
res/strings/en/strings.json: bin/combinestrings ${en_strings_files}
	hl bin/combinestrings en
########################################################################################################################

# set the graphics path
GRAPHICS_PATH=res/graphics/
asset_jsons = $(shell ls raw/*.json)
asset_pngs = $(shell ls raw/*.png)

assets: assetsmove ${GRAPHICS_PATH}/packed.json

assetsmove:
	-mv assets/ase/*.json raw/. 2> /dev/null
	-mv assets/ase/*.png raw/. 2> /dev/null

${GRAPHICS_PATH}/packed.json: ${asset_jsons} ${asset_pngs}
	./bin/asepritepack.py ${GRAPHICS_PATH}/packed.png:${GRAPHICS_PATH}/packed.json \
		raw/font32.png:raw/font32.json
########################################################################################################################
# Build for Distributions
# @note: we can also build windows on mac, since it is run in VM
# uncomment when necessary
dist: dist-web # dist-mac dist-windows dist-steam dist-steam-demo

dist-web: js
	mkdir -p build/web
	cd ${JS_BUILD_PATH}; zip ../web/web.zip *

dist-mac: mac
	mkdir -p build/mac/${FOLDERNAME}
	cp -r build/mac/${MACAPP} build/mac/${FOLDERNAME}/.
	cp build_script/mac/README.txt build/mac/${FOLDERNAME}/.
	cd build/mac; zip -r ${MAC_DIST} ${FOLDERNAME}

dist-windows: windows
	cd build/windows; zip -r ${WINDOWS_DIST} ${FOLDERNAME}

dist-steam: steam

dist-steam-demo: steam-demo
########################################################################################################################
# Push
push-all: push-web push-mac push-windows push-steam push-steam-demo

push-web:
	butler push build/web/web.zip ${ITCH_URL}:web --userversion ${VERSION}

push-web-private:
	butler push build/web/web.zip ${PRIVATE_ITCH_URL}:web --userversion ${VERSION}

push-mac:
	butler push build/mac/${MAC_DIST} ${ITCH_URL}:mac --userversion ${VERSION}

push-windows:
	butler push build/windows/${WINDOWS_DIST} ${ITCH_URL}:windows --userversion ${VERSION}

push-steam:
	steamcmd +login ${STEAM_USER} +run_app_build ${PWD}/build/steam/${STEAM_BUILD_FILE} +quit

push-steam-demo:
	steamcmd +login ${STEAM_USER} +run_app_build ${PWD}/build/steam-demo/${STEAM_DEMO_BUILD_FILE} +quit
########################################################################################################################
# archive build
# we will not archive the steam build for now
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
########################################################################################################################
clean:
	rm -f ./game.hl
	rm -f -r build/*
	rm -f res.pak
