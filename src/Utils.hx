/**
    Utils store all the functions that generally useful for the whole repo, but not yet lib/common level.

    For the globals variable, see Globals.hx
    For constants, see Constants.hx

**/
class Utils {
    public static function colorFontWrap(text: String, color: Int): String {
        return
            '<font color="#${StringTools.hex(color & 0xFFFFFF, 6)}">${StringTools.htmlEscape(text)}</font>';
    }
}
