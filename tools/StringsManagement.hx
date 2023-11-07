import haxe.DynamicAccess;

using StringTools;

typedef LoadedFile = {
	public var name: String;
	public var fullPath: String;
	public var pathKey: String;
	public var xml: Xml;
}

/**
	Combine all the xml strings into json files, 1 per language


**/
typedef StringsManagementConf = {
	public var ?lang: Array<String>;
}

class StringsManagement {
	var path: String;

	var conf: StringsManagementConf;

	var loaded: Map<String, Map<String, String>>;

	var loadedFiles: Map<String, LoadedFile>;

	var langsAvailable: Map<String, Bool>;
	var refs: Map<String, String>;
	var emptyKeys: Map<String, Bool>;

	public function new(path: String, conf: StringsManagementConf) {
		this.path = path;
		this.conf = conf;
		// this stores all the denormalised strings
		this.refs = new Map<String, String>();
		this.loaded = new Map<String, Map<String, String>>();
		this.loadedFiles = new Map<String, LoadedFile>();
		this.langsAvailable = new Map<String, Bool>();
		this.emptyKeys = new Map<String, Bool>();
	}

	// ---- Load all the strings ---- //
	function load() {
		parseFolder("data/strings/xml", "");
	}

	function parseFolder(fdrPath: String, keyPath: String) {
		final paths = sys.FileSystem.readDirectory(fdrPath);
		for (path in paths) {
			final fullpath = '${fdrPath}/${path}';
			if (sys.FileSystem.isDirectory(fullpath)) {
				parseFolder(fullpath, keyPath == "" ? path : '${keyPath}.${path}');
			} else {
				if (path.endsWith('.xml')) {
					try {
						var content = sys.io.File.getContent(fullpath);
						final document = Xml.parse(content);
						cleanDocument(document.firstElement());
						final lf: LoadedFile = {
							name: path,
							fullPath: fullpath,
							pathKey: keyPath,
							xml: document
						};
						this.loadedFiles[fullpath] = lf;
						parseDataXml(document.firstElement(), keyPath);
					} catch (e) {
						trace('Fail to parse XML: ${path}');
						throw e;
					}
				}
			}
		}
	}

	/**
		Remove all the unnecessary text in between the xml that is indentation
	**/
	function cleanDocument(element: Xml) {
		switch (element.nodeName) {
			case "group":
				for (child in element.elements()) {
					cleanDocument(child);
				}
				final toRemove: Array<Xml> = [];
				for (c in element) {
					if (c.nodeType == Xml.PCData) toRemove.push(c);
				}
				for (c in toRemove) element.removeChild(c);
			case "text":
				final toRemove: Array<Xml> = [];
				for (c in element) {
					if (c.nodeType == Xml.PCData) toRemove.push(c);
				}
				for (c in toRemove) element.removeChild(c);
		}
	}

	function parseDataXml(element: Xml, path: String) {
		switch (element.nodeName) {
			case "group":
				final id = element.get("id");
				final newPath = path + (id == null ? "" : ((path == "" ? "" : ".") + id));
				for (child in element.elements()) {
					parseDataXml(child, newPath);
				}
			case "text":
				final fullPath = path + "." + element.get("id");
				if (this.loaded.exists(fullPath)) throw new haxe.Exception('Duplicated Key exists - ${fullPath}');
				if (element.get("ref") != null) {
					var ref = element.get("ref");
					if (ref.startsWith(".")) ref = path + ref;
					this.refs[fullPath] = ref;
				} else {
					var langs = new Map<String, String>();
					var isEmpty = element.get("empty") != null;
					if (isEmpty == true) {
						this.emptyKeys[fullPath] = true;
					} else {
						for (e in element.elements()) {
							this.langsAvailable[e.nodeName] = true;
							if (isEmpty == true) {
								langs[e.nodeName] = "";
							} else {
								final nodeValue = trimXMLText(e.firstChild().nodeValue);
								e.firstChild().nodeValue = nodeValue;
								if (nodeValue == "") trace('Empty string found for ${fullPath}');
								langs[e.nodeName] = nodeValue;
							}
						}
						this.loaded[fullPath] = langs;
					}
				}
		}
	}

	function verify() {
		trace("---- Ensuring that all languages exist in all keys ---- ");
		for (key => langs in this.loaded) {
			for (lang => _ in this.langsAvailable) {
				if (langs.exists(lang) == false) {
					trace('string for "${key}.${lang}" not found.');
				}
			}
			for (lang => string in langs) {
				var br = replaceWithBrackets(string);
				var bk = replaceWithColon(br);
				if (bk != string) {
					trace('- Bracket and Colon switching breaks for ${key}.${lang} -');
					trace('- Original -');
					trace(string);
					trace('- Brackets -');
					trace(br);
					trace('- Colon -');
					trace(bk);
				}
			}
		}
		for (key => ref in this.refs) {
			if (this.loaded.exists(ref) == false) {
				trace('ref "${ref}" not found for key "${key}"');
			}
		}

		trace("---- Done ----");
	}

	function write(rootPath: String) {
		final output = new Map<String, Array<{key: String, str: String}>>();
		for (lang => _ in this.langsAvailable) {
			output[lang] = [];
		}
		for (key => langs in this.loaded) {
			for (lang => str in langs) {
				output[lang].push({key: key, str: trimXMLText(str)});
			}
			for (key => _ in this.emptyKeys) {
				for (_ => arr in output) {
					arr.push({key: key, str: ""});
				}
			}
		}

		for (key => ref in this.refs) {
			if (this.loaded.exists(ref) == false) {
				trace('ref "${ref}" not found for key "${key}"');
				continue;
			}
			final o = this.loaded[ref];
			for (lang => str in o) {
				output[lang].push({key: key, str: trimXMLText(str)});
			}
		}

		for (lang => arrStr in output) {
			var strings: DynamicAccess<Dynamic> = {};
			arrStr.sort((s1, s2) -> {
				return zf.Compare.string(true, 1, s1.key, s2.key);
			});
			for (v in arrStr) {
				zf.Struct.setValueByKeys(strings, v.key.split("."), v.str);
			}
			final path = new haxe.io.Path('${rootPath}/${lang}/strings.json');
			var directory = path.dir;
			if (!sys.FileSystem.exists(directory)) {
				sys.FileSystem.createDirectory(directory);
			}
			sys.io.File.saveContent(path.toString(), haxe.Json.stringify(strings, "  "));
		}
	}

	/**
		This only output all the keys that need to be translated.
		Only output en keys
	**/
	function writeKeys(path: String) {
		var strings: Array<Dynamic> = [];
		for (key => langs in this.loaded) {
			if (this.emptyKeys.exists(key)) continue;
			final output: DynamicAccess<Dynamic> = {};
			for (lang => str in langs) {
				output.set(lang, replaceWithBrackets(trimXMLText(str)));
			}
			output.set("key", key);
			strings.push(output);
		}
		strings.sort((s1, s2) -> {
			return zf.Compare.string(true, 1, s1.key, s2.key);
		});
		sys.io.File.saveContent(path.toString(), haxe.Json.stringify(strings, "  "));
	}

	/**
		Convert haxe template format ::XXX:: with [XXX].
		The content inside is not changed.
	**/
	function replaceWithBrackets(s: String): String {
		var str = new StringBuf();

		var start = s.indexOf("::", 0);
		if (start == -1) return s;

		var end = start;
		str.add(s.substring(0, start));
		while (start != -1) {
			end = s.indexOf("::", start + 2);
			str.add('[');
			str.add(s.substring(start + 2, end));
			str.add(']');
			start = s.indexOf("::", end + 2);
			if (start != -1) {
				str.add(s.substring(end + 2, start));
			} else {
				str.add(s.substr(end + 2));
			}
		}

		return str.toString();
	}

	/**
		Convert haxe template format [XXX] with ::XXX::.
		The content inside is not changed.
	**/
	function replaceWithColon(s: String): String {
		// check if there are any "escape character", if so we will replace it with _SQUARE_ first
		s = s.replace("\\[", "__SQUARE_LEFT__").replace("\\]", "__SQUARE_RIGHT__");
		s = s.replace("[", "::").replace("]", "::");
		s = s.replace("__SQUARE_LEFT__", "[").replace("__SQUARE_RIGHT__", "]");

		return s;
	}

	// ---- import string and update the key ---- //
	function importLang(path: String, langKey: String) {
		// load the json first
		final content = sys.io.File.getContent(path);
		final data: {entries: Array<Dynamic>} = haxe.Json.parse(content);
		final strings: Map<String, String> = [];
		for (entry in data.entries) {
			final e: DynamicAccess<Dynamic> = entry;
			if (e.exists("key") == false || e.exists(langKey) == false) continue;
			strings[e.get("key")] = e.get(langKey);
		}

		function parseXml(element: Xml, path: String) {
			switch (element.nodeName) {
				case "group":
					final id = element.get("id");
					final newPath = path + (id == null ? "" : ((path == "" ? "" : ".") + id));
					for (child in element.elements()) {
						parseXml(child, newPath);
					}
				case "text":
					if (element.get("ref") != null || element.get("empty") != null) return;
					final fullPath = path + "." + element.get("id");
					final id = element.get("id");
					final translated = strings.get(fullPath);
					if (translated == null || translated.trim() == "") return;
					final parsed = trimXMLText(replaceWithColon(translated));
					// check if we already have a children with the lang key
					final existings = element.elementsNamed(langKey);
					final existing = existings.hasNext() ? existings.next() : null;
					if (existing != null) {
						existing.firstChild().nodeValue = parsed;
					} else {
						final node = Xml.createElement(langKey);
						final pcdata = Xml.createPCData(parsed);
						node.addChild(pcdata);
						element.addChild(node);
					}
			}
		}

		function importFile(file: LoadedFile) {
			parseXml(file.xml.firstElement(), file.pathKey);
		}

		for (_ => file in loadedFiles) importFile(file);
		for (_ => file in loadedFiles) {
			sys.io.File.saveContent(file.fullPath, zf.xml.Printer.print(file.xml.firstElement(), {
				pretty: true,
				singleLinePCData: true,
				useSpaceAsTab: 2,
				alignPCData: true,
			}));
		}
	}

	static function main() {
		var args = Sys.args();
		var conf: StringsManagementConf = {};

		final parser = new StringsManagement("data/string/xml", conf);
		parser.load();

		var command = "";
		if (args.length == 0) {
			command = "verify";
		} else {
			if (args[0] == "verify") {
				command = "verify";
				args = args.slice(1);
			} else if (args[0] == "write") {
				command = "write";
				args = args.slice(1);
			} else if (args[0] == "writekeys") {
				command = "writekeys";
				args = args.slice(1);
			} else if (args[0] == "import") {
				command = "import";
				args = args.slice(1);
			}
		}

		if (command == "verify") {
			parser.verify();
		} else if (command == "write") {
			var path = "res/strings";
			parser.write(path);
		} else if (command == "writekeys") {
			var path = "export/en.json";
			parser.writeKeys(path);
		} else if (command == "import") {
			var path = args[0];
			var key = args[1];
			// this should already be json
			parser.importLang(path, key);
		} else {
			trace('Unimplemented command ${command}');
		}
	}

	static function trimXMLText(t: String, eol = '\n') {
		t = t.trim();
		var strings = t.split("\n");
		strings = [for (s in strings) s.trim()];
		return strings.join(eol);
	}
}
