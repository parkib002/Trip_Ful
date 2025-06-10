package review;

public class ReportDto {
	private String report_idx;
	private String member_id;
	private int like;
	private String report_content;
	private int report_cnt;
	private String review_idx;
	
	public String getReport_idx() {
		return report_idx;
	}
	public void setReport_idx(String report_idx) {
		this.report_idx = report_idx;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public int getLike() {
		return like;
	}
	public void setLike(int like) {
		this.like = like;
	}
	public String getReport_content() {
		return report_content;
	}
	public void setReport_content(String report_content) {
		this.report_content = report_content;
	}
	public int getReport_cnt() {
		return report_cnt;
	}
	public void setReport_cnt(int report_cnt) {
		this.report_cnt = report_cnt;
	}
	public String getReview_idx() {
		return review_idx;
	}
	public void setReview_idx(String review_idx) {
		this.review_idx = review_idx;
	}
	
	
}
