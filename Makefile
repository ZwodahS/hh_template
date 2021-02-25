game: assets
	haxe build_script/common.hxml build_script/debug.hxml --hl game.hl --main Main

debug:
	rm -f .breakpoints
	touch .breakpoints
	haxe build_script/common.hxml build_script/debug.hxml --hl game.hl --main Main -D debugger

lint:
	haxelib run formatter -s src

js: assets pak
	haxe build_script/common.hxml build_script/js.hxml --no-traces --main Main
	cp build_script/index.html build/js/.
	cp res.pak build/js/.

jsdebug: assets pak
	haxe build_script/common.hxml build_script/js.hxml -D debug -D loggingLevel=30 --main Main
	cp build_script/index.html build/js/.
	cp res.pak build/js/.

hl: assets
	haxe build_script/common.hxml build_script/hl.hxml --no-traces --main Main

gcc: c
	rm -f ./game
	gcc -O3 -o game -I build/c/ build/c/game.c -lhl /usr/local/lib/*.hdll

pak:
	haxe -hl hxd.fmt.pak.Build.hl -lib heaps -main hxd.fmt.pak.Build
	hl hxd.fmt.pak.Build.hl

c: assets
	haxe build_script/common.hxml build_script/c.hxml

assets: res/packed.json

res/packed.json:
	./bin/asepritepack.py res/packed.png:res/packed.json \
		raw/font32.png:raw/font32.json \

itch:
	cd build/js; zip ../../itch.zip *

clean:
	rm -f ./game
	rm -f ./game.hl
	rm -f -r build/*
