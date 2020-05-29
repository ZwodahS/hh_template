
assets:
	./raw/convert_from_asejson.py ./raw/cards.ase.json ./res/cards.json
	cp ./raw/*.png ./res/.

test:
	haxe build_script/common.hxml build_script/test.hxml

help:
	@echo "make [js|hl|test|c]"

js:
	haxe build_script/common.hxml build_script/js.hxml
	cp build_script/index.html build/js/.

hl:
	haxe build_script/common.hxml build_script/hl.hxml

c:
	rm -f ./game
	haxe build_script/common.hxml build_script/c.hxml
	gcc -O3 -o game -I build/c/ build/c/game.c -lhl /usr/local/lib/*.hdll

itch:
	cd build/js; zip ../../itch.zip *

clean:
	rm -f ./game
	rm -f ./game.hl
	rm -f -r build/*
