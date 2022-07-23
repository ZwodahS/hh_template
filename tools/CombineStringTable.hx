import haxe.DynamicAccess;
using StringTools;

/**
	Combine all the data in /data/strings/{langs}/....
	Currently will only process xml files

	Element allowed

		- group
		- const
		- text

	For const, these will be used in haxe.Template.globals
	For text, these will be part of the string table.

	For const, they will be exported to res/strings/en/consts.json
	For text, they will be exported to res/strings/en/strings.json

	For const, group id and various stuffs are ignored.
	For text, each group with id will create a nested dict.
	Each group is also considered as a group and the folder name is become part of the key
**/
class CombineStringTable {

	static function main() {
		var args = Sys.args();
		if (args.length == 0) {
		// read the data directory
			final langs = sys.FileSystem.readDirectory("data/strings");

			for (lang in langs) {
				parseLang(lang);
			}
		} else {
			for (lang in args) {
				parseLang(lang);
			}
		}
	}

	static function parseLang(lang: String) {
		trace('-- Parsing lang: ${lang}');
		final consts: DynamicAccess<Dynamic> = {};
		final strings: DynamicAccess<Dynamic> = {};

		parseFolder('data/strings/${lang}', consts, strings);

		final path = new haxe.io.Path('res/strings/${lang}/strings.json');
		var directory = path.dir;
		if (!sys.FileSystem.exists(directory)) {
			sys.FileSystem.createDirectory(directory);
		}
		sys.io.File.saveContent(path.toString(), haxe.Json.stringify(strings, "  "));
	}

	static function parseFolder(fdrPath: String, consts: DynamicAccess<Dynamic>, strings: DynamicAccess<Dynamic>) {
		final paths = sys.FileSystem.readDirectory(fdrPath);
		for (path in paths) {
			final fullpath = '${fdrPath}/${path}';
			if (sys.FileSystem.isDirectory(fullpath)) {
				final newStrings: DynamicAccess<Dynamic> = {};
				strings.set(path, newStrings);
				parseFolder(fullpath, consts, newStrings);
			} else {
				var content = sys.io.File.getContent(fullpath);
				if (path.endsWith('.xml')) {
					parseXML(content, consts, strings);
				}
			}
		}
	}

	static function parseXML(content: String, consts: DynamicAccess<Dynamic>, strings: DynamicAccess<Dynamic>) {
		final xml = Xml.parse(content);

		// recursively parse xml
		function parse(element: Xml, c: DynamicAccess<Dynamic>, s: DynamicAccess<Dynamic>) {
			switch(element.nodeName) {
				case "group":
					final id = element.get("id");
					if (id != null) {
						var newStrings: DynamicAccess<Dynamic> = {};
						s.set(id, newStrings);
						s = newStrings;
					}
					for (child in element.elements()) {
						parse(child, c, s);
					}
				case "text":
					final id = element.get("id");
					if (id == null) return;
					final access = new haxe.xml.Access(element);
					final str = trimXMLText(access.innerHTML);
					s.set(id, str);
				case "const":
					final id = element.get("id");
					if (id == null) return;
					final access = new haxe.xml.Access(element);
					final str = trimXMLText(access.innerHTML);
					c.set(id, str);
			}
		}

		parse(xml.firstElement(), consts, strings);
	}

	static function trimXMLText(t: String, eol = '\n') {
		t = t.trim();
		var strings = t.split("\n");
		strings = [for (s in strings) s.trim()];
		return strings.join(eol);
	}
}
