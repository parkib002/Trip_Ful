package board;

import java.sql.Timestamp;

public class BoardSupportDto {
	private String qna_idx;
	private String qna_title;
	private String qna_content;
	private String qna_img;
	private int qna_readcount;
	private Timestamp qna_writeday;
	private String qna_writer;
	private String qna_private;
	private String qna_category;
	private int regroup;
	private int restep;
	private int relevel;
	
	public String getQna_idx() {
		return qna_idx;
	}
	public void setQna_idx(String qna_idx) {
		this.qna_idx = qna_idx;
	}
	public String getQna_title() {
		return qna_title;
	}
	public void setQna_title(String qna_title) {
		this.qna_title = qna_title;
	}
	public String getQna_content() {
		return qna_content;
	}
	public void setQna_content(String qna_content) {
		this.qna_content = qna_content;
	}
	public String getQna_img() {
		return qna_img;
	}
	public void setQna_img(String qna_img) {
		this.qna_img = qna_img;
	}
	public int getQna_readcount() {
		return qna_readcount;
	}
	public void setQna_readcount(int qna_readcount) {
		this.qna_readcount = qna_readcount;
	}
	public Timestamp getQna_writeday() {
		return qna_writeday;
	}
	public void setQna_writeday(Timestamp qna_writeday) {
		this.qna_writeday = qna_writeday;
	}
	public String getQna_writer() {
		return qna_writer;
	}
	public void setQna_writer(String qna_writer) {
		this.qna_writer = qna_writer;
	}
	public String getQna_private() {
		return qna_private;
	}
	public void setQna_private(String qna_private) {
		this.qna_private = qna_private;
	}
	public String getQna_category() {
		return qna_category;
	}
	public void setQna_category(String qna_category) {
		this.qna_category = qna_category;
	}
	public int getRegroup() {
		return regroup;
	}
	public void setRegroup(int regroup) {
		this.regroup = regroup;
	}
	public int getRestep() {
		return restep;
	}
	public void setRestep(int restep) {
		this.restep = restep;
	}
	public int getRelevel() {
		return relevel;
	}
	public void setRelevel(int relevel) {
		this.relevel = relevel;
	}
	
	
	
	
	
}
