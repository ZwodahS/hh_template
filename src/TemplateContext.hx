/**
	A way to update the template context without screwing things up.
**/
class TemplateContext {
	public var context: Dynamic;

	var icons: Dynamic;
	var keywords: Dynamic;
	var escape: Dynamic;

	public function new() {
		this.icons = {};
		this.keywords = {};
		this.escape = {
			lt: '&lt;',
			lte: '&lt;=',
			gt: '&gt;',
			gte: '&gt;=',
		};

		this.context = {
			eol: "<br/>",
			i: icons,
			keywords: this.keywords,
			escape: this.escape,
			colors: Colors.TemplateColors,
		};
	}

	function getColor(color: Color): String {
		return '<font color="#${StringTools.hex(color & 0xFFFFFF, 6)}">';
	}

	public function setKeywords(c: Dynamic) {
		this.keywords = c;
		this.context.keywords = this.keywords;
	}
}
