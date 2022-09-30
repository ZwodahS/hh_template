package userdata;

class Profile {
	public final profile: zf.userdata.UserProfile;

	public function new(profile: zf.userdata.UserProfile) {
		this.profile = profile;
	}

	public function load() {}
}
