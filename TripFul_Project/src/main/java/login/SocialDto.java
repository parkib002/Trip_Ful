package login;

public class SocialDto {
	String social_provider, social_provider_key, member_idx;
	

	public String getMember_idx() {
		return member_idx;
	}

	public void setMember_idx(String member_idx) {
		this.member_idx = member_idx;
	}

	public String getSocial_provider() {
		return social_provider;
	}

	public void setSocial_provider(String social_provider) {
		this.social_provider = social_provider;
	}

	public String getSocial_provider_key() {
		return social_provider_key;
	}

	public void setSocial_provider_key(String social_provider_key) {
		this.social_provider_key = social_provider_key;
	}
	
	
}
