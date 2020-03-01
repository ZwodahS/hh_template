
all:
	@echo "make [js|hl|test]"

js:
	haxe build_script/js.hxml
	cp build_script/index.html build/js/.

hl:
	haxe build_script/hl.hxml

test:
	haxe build_script/test.hxml

debug:
	haxe build_script/test.hxml --debug

itch:
	cd build/js; zip ../../itch.zip *
