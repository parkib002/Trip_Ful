package review;

import java.security.Timestamp;

public class ReviewDto {
	private String review_idx;
	private String review_id;
	private String review_content;
	private String review_img;
	private String review_name;
	private int review_star;
	private Timestamp review_writeday;
	private String place_num;
	
	
	
	@Override
	public String toString() {
		return "ReviewDto [review_idx=" + review_idx + ", review_id=" + review_id + ", review_content=" + review_content
				+ ", review_img=" + review_img + ", review_name=" + review_name + ", review_star=" + review_star
				+ ", review_writeday=" + review_writeday + ", place_num=" + place_num + "]";
	}
	public String getReview_idx() {
		return review_idx;
	}
	public void setReview_idx(String review_idx) {
		this.review_idx = review_idx;
	}
	public String getReview_id() {
		return review_id;
	}
	public void setReview_id(String review_id) {
		this.review_id = review_id;
	}
	public String getReview_content() {
		return review_content;
	}
	public void setReview_content(String review_content) {
		this.review_content = review_content;
	}
	public String getReview_img() {
		return review_img;
	}
	public void setReview_img(String review_img) {
		this.review_img = review_img;
	}
	public String getReview_name() {
		return review_name;
	}
	public void setReview_name(String review_name) {
		this.review_name = review_name;
	}
	public int getReview_star() {
		return review_star;
	}
	public void setReview_star(int review_star) {
		this.review_star = review_star;
	}
	public Timestamp getReview_writeday() {
		return review_writeday;
	}
	public void setReview_writeday(Timestamp review_writeday) {
		this.review_writeday = review_writeday;
	}
	public String getPlace_num() {
		return place_num;
	}
	public void setPlace_num(String place_num) {
		this.place_num = place_num;
	}
	
	
	
}
