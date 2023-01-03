private class ExternalButton extends zf.ui.UIElement {
	var render: h2d.Object;

	public function new(icon: h2d.Object, text: String, link: String) {
		super();
		this.render = new h2d.Object();
		this.render.addChild(icon);

		final t = new h2d.HtmlText(Assets.displayFonts[2]);
		t.text = text;
		t.textColor = Colors.Whites[2];
		t.dropShadow = {
			dx: 1,
			dy: 1,
			color: Colors.Blacks[0],
			alpha: .4
		};
		this.render.addChild(t.putOnRight(icon, [4, 0]).centerYWithin(icon));

		final bound = this.render.getBounds();

		final interactive = new Interactive(bound.width, bound.height);
		this.interactive = interactive;
		this.render.addChild(interactive);

		this.addOnOverListener("Links", (e) -> {
			t.textColor = Colors.HighlightGreen;
		});

		this.addOnOutListener("Links", (e) -> {
			t.textColor = Colors.Whites[2];
		});

		this.addOnClickListener("Links", (e) -> {
			hxd.System.openURL(link);
		});

		this.addChild(this.render);
	}
}

class Links {
	public static final MastodonLink = "https://mastodon.gamedev.place/@ZwodahS";
	public static final DiscordLink = "https://discord.gg/BsNrBVf8ev";
	public static final TwitterLink = "https://twitter.com/ZwodahS";

	public static function makeButton(nameId: String, assetId: String, link: String) {
		final icon = Assets.res.getBitmap(assetId);
		final btn = new ExternalButton(icon, Strings.get(nameId), link);
		return btn;
	}

	public static function getMastodonBtn(): h2d.Object {
		return makeButton("external.mastodon", "links:external:mastodon", MastodonLink);
	}

	public static function getDiscordBtn(): h2d.Object {
		return makeButton("external.discord", "links:external:discord", DiscordLink);
	}

	public static function getTwitterBtn(): h2d.Object {
		return makeButton("external.twitter", "links:external:twitter", TwitterLink);
	}
}
