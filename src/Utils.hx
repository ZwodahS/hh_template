/**
	Utils store all the functions that generally useful for the whole repo, but not yet lib/common level.

	For the globals variable, see Globals.hx
	For constants, see Constants.hx

**/
class Utils {
	public static function stackItemToString(s: haxe.CallStack.StackItem) {
		switch (s) {
			case Module(m):
				return '${m}';
			case FilePos(s, file, line, _):
				if (s == null) {
					return '${file}:${line}';
				} else {
					return '${stackItemToString(s)} (${file}:${line})';
				}
			case Method(cn, method):
				if (cn == null) return '${method}';
				return '${cn}.${method}';
			case LocalFunction(v):
				return '$' + '${v}';
			case CFunction:
				return 'CFunction';
		}
	}
}
