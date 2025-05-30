package place;

public class PlaceDto {

	private String place_num;
	private String country_name;
	private String place_img;
	private String place_content;
	private String place_tag;
	private String place_code;
	private String place_name;
	private int place_count;
	private String continent_name;
	private String place_addr;
	private int place_like;
	
	public int getPlace_like() {
		return place_like;
	}
	public void setPlace_like(int place_like) {
		this.place_like = place_like;
	}
	public String getPlace_name() {
		return place_name;
	}
	public String getPlace_addr() {
		return place_addr;
	}
	public void setPlace_addr(String place_addr) {
		this.place_addr = place_addr;
	}
	public void setPlace_name(String place_name) {
		this.place_name = place_name;
	}
	public String getPlace_num() {
		return place_num;
	}
	public void setPlace_num(String place_num) {
		this.place_num = place_num;
	}
	public String getCountry_name() {
		return country_name;
	}
	public void setCountry_name(String country_name) {
		this.country_name = country_name;
	}
	public String getPlace_img() {
		return place_img;
	}
	public void setPlace_img(String place_img) {
		this.place_img = place_img;
	}
	public String getPlace_content() {
		return place_content;
	}
	public void setPlace_content(String place_content) {
		this.place_content = place_content;
	}
	public String getPlace_tag() {
		return place_tag;
	}
	public void setPlace_tag(String place_tag) {
		this.place_tag = place_tag;
	}
	public String getPlace_code() {
		return place_code;
	}
	public void setPlace_code(String place_code) {
		this.place_code = place_code;
	}
	public int getPlace_count() {
		return place_count;
	}
	public void setPlace_count(int place_count) {
		this.place_count = place_count;
	}
	public String getContinent_name() {
		return continent_name;
	}
	public void setContinent_name(String continent_name) {
		this.continent_name = continent_name;
	}
}
