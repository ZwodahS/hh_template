
all:
	@echo "make [js|hl]"

js:
	haxe build_script/js.hxml

hl:
	haxe build_script/hl.hxml

test:
	haxe build_script/test.hxml

graphics:
	pack_assets.py assets/font32 res/font32
